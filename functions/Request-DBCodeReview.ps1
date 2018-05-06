﻿Function Request-DBCodeReview {
<#
    .SYNOPSIS
        As a developer, I would like to have some code deployed. 
        As a DBA, I would like you to stop emailing me. 
        Go-go gadget Powershell!

    .DESCRIPTION
        Given a secured-but-readable "prod" environment and a fully open "qa" evironment, 
            the default behavior of this function is to...
                1) format a list of objects to be reviewed
                2) read the definition of each object from both the "source" and "target" servers
                3) write the current definition of each object to a corresponding git branch
                4) launch a web session to request a code review by way of a pull request
        By default, we make the "target" a static branch named "develop". This allows for
            multiple concurrent code reviews to be approved separately but deployed together. 

    .PARAMETER BypassForceUpdate
        During typical use, we want to force devs onto the latest version of the module 
            PRIOR TO intteracting with the repo. When someone complains that "a thing went wrong!",
            you only want to have one version of the module to debug
        For local testing & advanced usage, specify this flag to skip an forceful override.

    .PARAMETER LocalOnly
        DO NOT auto-push to the remote. 
#>
    [cmdletbinding()]Param(
         [parameter(mandatory=$true)]
            [ValidateNotNullOrEmpty()]
            [string[]]$objList
        ,[string]$sourceBranch
        ,[string]$targetBranch
        ,[string]$sourceServer
        ,[string]$targetServer
        ,[string]$targetEnv
        ,[string]$sourceEnv
        ,[switch]$LocalOnly
        ,[switch]$BypassForceUpdate
    )
    $repo = (Get-GitRepo)

    if(-not $repo.IsRepo){
        Write-Warning "Oops! Looks like you're not where you need to be. Please Set-Location 'c:\my-git-repo' and try again."
        return
    }
    Set-Location $repo.RootFullPath 

    if($BypassForceUpdate){
    } else {
        Enter-GitBranch master
        Import-Module ../SqlCodeReview -Force
    }

    $curBranch = $repo.CurrentBranch

    if([string]::IsNullOrWhiteSpace($targetEnv)){$targetEnv = "prod"}
    if([string]::IsNullOrWhiteSpace($sourceEnv)){$sourceEnv = "qa"}
    if([string]::IsNullOrWhiteSpace($targetBranch)){
        $targetBranch = "develop"
    }
    if([string]::IsNullOrWhiteSpace($sourceBranch)){
        $sourceBranch =  ($env:UserName -replace '[^a-zA-Z]', '').Substring(0,6) 
        $sourceBranch += (1..6 | ForEach-Object {'{0:X}' -f (Get-Random -Max 16)}) -join ''
    }
    
    $objList = Format-SqlObjectList -objList $objList.Split(',')

    git fetch 
    Enter-GitBranch -branchName $targetBranch -Force

    $objList | ConvertTo-Csv | Out-File "log/$($sourceBranch)_PRLOG.csv" -Encoding ascii -Force

#1 prod srvr to repo
    Write-SqlObjListToLocalPath `
        -FromServer $targetServer `
        -objList    $objList `
        -env        $targetEnv `
        -Verbose

    Write-Verbose "TARGET: Adding, committing, publishing branch and pushing"
    git add .
    git commit -m "Syncing state from $targetServer/$targetEnv For '$targetBranch'."
    if($LocalOnly){
    }else{git push -u origin $targetBranch}

#2 already in prod-base. moving FROM here TO dev-base keeps diff fwd-only
    Enter-GitBranch -branchName $sourceBranch -Force

#3 dev srvr to repo
    Write-SqlObjListToLocalPath `
        -FromServer $sourceServer `
        -objList    $objList `
        -env        $sourceEnv `
        -Verbose

    Write-Verbose "SOURCE: Adding, committing, publishing branch and pushing"
    git add .
    git commit -m "Syncing state from $sourceServer/$sourceEnv for '$sourceBranch'."
    if($LocalOnly){
    }else{git push -u origin $sourceBranch}

#4 jump up to remote to merge dev into prod
    $repoUrl = $repo.RemoteURL

    $prUrl = switch ($repo.Provider) {
       'vsts'   {"$repoUrl/PullRequestCreate?sourceRef=$sourceBranch&targetRef=$targetBranch"}
       'github' {"$repoUrl/compare/$targetBranch...$sourceBranch"}
    }  

    if($LocalOnly){
        Write-Host "LOCALONLY was specified, you will need to manually push to open a remote PR.`n" -ForegroundColor Yellow
        Write-Host "    $repoUrl" -ForegroundColor Yellow
        Write-Host "`ngit checkout $targetBranch" -ForegroundColor Yellow
        Write-Host "git push --set-upstream origin $targetBranch" -ForegroundColor Yellow
        Write-Host "git checkout $sourceBranch" -ForegroundColor Yellow
        Write-Host "git push --set-upstream origin $sourceBranch`n" -ForegroundColor Yellow
        Write-Host "    $repoUrl" -ForegroundColor Yellow
        Write-Host "`nDon't forget to execute the below command when you're all done." -ForegroundColor Red
        Write-Host "`nEnter-GitBranch $curBranch" -ForegroundColor Yellow
    }else{
        Write-Verbose "Launching Chrome for PR"
        Enter-GitBranch $curBranch
        Start-Process chrome $prUrl
    }
}
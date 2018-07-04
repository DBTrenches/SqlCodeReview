Function Get-GitRepo {
<#
    .SYNOPSIS
        Return some information about a git repo 

    .TODO
        Add pattern-matching for vsts ssh. Currently assuming following patterns below.
            https://github.com/$org/$repo.git
            git@github.com:$org/$repo.git
            https://$org.visualstudio.com/$project/_git/$repo
            ssh://$org@vs-ssh.visualstudio.com:$port/$project/_ssh/$repo

    .TODO
        Transform VSTS+SSH remote origin into web-launchable URL.
#>
    [CmdletBinding()]Param(
         [Alias('dir','at')]
             $directory = "."
        ,$project
    )
    $curDir = (Get-Location).Path
    
    if(-not [string]::IsNullOrWhiteSpace($project)){
        try{
            Write-Verbose "Project [$project] was specified. Inferring repo LocalPath from config."
            $directory = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.LocalPath
        }
        catch{
            throw "An error occured attempting to parse the LocalPath for supplied project [$project]."
        }
    }

    if(-not (Test-Path $directory)){
        throw "Supplied directory [$directory] was not discovered. Process will exit."
    }

    Set-Location $directory

    $remoteUrl = (git config --get remote.origin.url)
    $isSsh = $false
    
    try{
        if($remoteUrl.StartsWith("git@github.com:")){
            $isSsh     = $true
            $remoteUrl = ($remoteUrl.Replace("git@github.com:","https://github.com/")) -replace ".{4}$"
        }
    }
    catch{
        $remoteUrl = ""
    }
    
    $provider = if($remoteUrl.Contains("github")){ "github" }
        elseif ($remoteUrl.Contains("visualstudio")){ "vsts" }

    $branches    = Get-GitBranch -ErrorAction SilentlyContinue
    $branchNames = $branches | Select-Object Name -Unique  

    $branches | Where-Object IsLocal | ForEach-Object {
        $localBranches += @{
            $PSItem.Name = $PSItem 
        }
    }

    $branches | Where-Object IsRemote | ForEach-Object {
        $remoteBranches += @{
            $PSItem.Name = $PSItem 
        }
    }
    
    [PSCustomObject]@{
        RootFullPath  = (git rev-parse --show-toplevel) 
        CurrentBranch = (git rev-parse --abbrev-ref HEAD)
        IsRepo        = (git rev-parse --show-toplevel) -ne $null
        RemoteURL     = $remoteUrl
        IsSsh         = $isSsh
        Provider      = $provider
        Branches      = @{
            Names  = $branchNames 
            Local  = $localBranches
            Remote = $remoteBranches
        }
    }

    Set-Location $curDir
}
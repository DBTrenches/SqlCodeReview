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
    )
    $curDir = (Get-Location).Path
    Set-Location $directory

    $remoteUrl = (git config --get remote.origin.url)
    $isSsh = $false
    
    if($remoteUrl.StartsWith("git@github.com:")){
        $isSsh     = $true
        $remoteUrl = ($remoteUrl.Replace("git@github.com:","https://github.com/")) -replace ".{4}$"
    }

    $provider = if($remoteUrl.Contains("github")){ "github" }
        elseif ($remoteUrl.Contains("visualstudio")){ "vsts" }

    $branches    = Get-GitBranch 
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
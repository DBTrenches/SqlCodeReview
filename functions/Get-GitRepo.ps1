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
        $dir = "."
    )
    $curDir = (Get-Location).Path
    Set-Location $dir

    $remoteUrl = (git config --get remote.origin.url)
    $isSsh = $false
    
    if($remoteUrl.StartsWith("git@github.com:")){
        $isSsh     = $true
        $remoteUrl = ($remoteUrl.Replace("git@github.com:","https://github.com/")) -replace ".{4}$"
    }

    $provider = if($remoteUrl.Contains("github")){ "github" }
        elseif ($remoteUrl.Contains("visualstudio")){ "vsts" }

    [PSCustomObject]@{
        RootFullPath  = (git rev-parse --show-toplevel) 
        CurrentBranch = (git rev-parse --abbrev-ref HEAD)
        IsRepo        = (git rev-parse --show-toplevel) -ne $null
        RemoteURL     = $remoteUrl
        IsSsh         = $isSsh
        Provider      = $provider
    }

    Set-Location $curDir
}
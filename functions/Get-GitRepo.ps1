Function Get-GitRepo {
<#
    .SYNOPSIS
        Return some information about a git repo 
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

    $provider = switch ($remoteUrl.Substring(0,19)) {
        'https://github.com/' { "github" }
        'https://viagogo.vis' { "vsts" }
    }

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
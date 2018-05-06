Function Assert-GitBranch{
    [cmdletbinding()]Param(
         [parameter(
            Mandatory=$true,
            Position=1)][string]$branchName
    )
    
    $branch = (Get-GitBranch | Where-Object {$PSItem.Name -eq $branchName})
    
    $exists    = if($branch.Exists){$true}else{$false}
    $isLocal   = $branch.IsLocal 
    $isRemote  = $branch.IsRemote
    $isCurrent = $branch.IsCurrent

    if(($branch | Measure-Object).Count -gt 1){
        $isLocal   = [bool]($branch.IsLocal   | Measure-Object -Maximum).Maximum
        $isRemote  = [bool]($branch.IsRemote  | Measure-Object -Maximum).Maximum
        $isCurrent = [bool]($branch.IsCurrent | Measure-Object -Maximum).Maximum
    }

    [PSCustomObject] @{
        Exists    = $exists
        IsLocal   = $isLocal
        IsRemote  = $isRemote
        IsCurrent = $isCurrent
    }
}
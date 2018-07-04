Function Assert-GitBranch{
    [cmdletbinding()]Param(
        [Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [string]$branchName
    )
    
    begin{}

    Process{
        if([string]::IsNullOrWhiteSpace($branchName)){
            $exists = $false
        }else{
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
        }

        [PSCustomObject] @{
            Exists    = $exists
            IsLocal   = $isLocal
            IsRemote  = $isRemote
            IsCurrent = $isCurrent
        }
    }
}
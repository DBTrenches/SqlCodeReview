Function Enter-GitBranch {
    [cmdletbinding()]Param(
         [string]$branchName
        ,[switch]$Force
    )

    $branch = Assert-GitBranch -branchName $branchName
    
    if($branch.IsCurrent){return}
    
    if($branch.Exists){
        git checkout $branchName --quiet
        return
    }
    
    if((-not $branch.Exists) -and $Force) {
        git checkout -b $branchName --quiet
    } 

    if(-not (Assert-GitBranch -branchName $branchName).IsCurrent) {
        Write-Warning "Branch '$branchName' not found. Use the -Force switch if creation is required." -ForegroundColor 
        return
    }
}
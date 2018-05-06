Function Enter-GitBranch {
    [cmdletbinding()]Param(
         [string]$branchName
        ,[switch]$Force
        ,[switch]$AllowClobber
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

    if($AllowClobber){
        Write-Warning "Branch '$branchName' exists upstream but has diverged locally. You're gonna have a bad time."
        git checkout -b $branchName --quiet
        return
    } 

    if(-not (Assert-GitBranch -branchName $branchName).IsCurrent) {
        Write-Warning "Branch '$branchName' not found. Use the -Force switch if creation is required." -ForegroundColor 
        return
    }
}
function Get-GitBranch {
# TODO: handle for not-same directory repo checks

    $branchList = (git branch -a).split("`n")

    foreach($_line in $branchList) {
        $line       = $_line.Substring(2,($_line.Length)-2)
        $isCurrent  = $_line.StartsWith("*")
        $isRemote   = $line.StartsWith("remotes/")
        $remoteName = $line.split("/")[1]
        $Head       = $line.contains("->")

        if(-not $isRemote){
            $branchName = $line
        } 

        if($isRemote){
            $branchName = $line.split("/")[2..20] -join '/' # TODO: make this suck less
        } 

        if($Head){
            $Head = @{
                LocalRef = $line.split("/")[1]
            }
            $branchName = "HEAD"
        } else { Remove-Variable -Name "Head" }

        [PSCustomObject] @{
            Type       = if($isRemote){"remote"}else{"local"}
            Name       = $branchName
            IsLocal    = (-not $isRemote)
            IsRemote   = $isRemote
            RemoteName = $remoteName
            IsCurrent  = $isCurrent
            Head       = $Head
            Exists     = $true
        }
    }
}
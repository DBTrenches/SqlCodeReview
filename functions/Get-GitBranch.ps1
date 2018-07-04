function Get-GitBranch {
# TODO: handle for not-same directory repo checks

    $branchList = (git branch -a).split("`n")

    foreach($_line in $branchList) {
        $line       = $_line.Substring(2,($_line.Length)-2)
        $isCurrent  = ($_line.Substring(0,1) -eq "*")
        $isRemote   = (($line.split("/")[0] -eq "remotes") -and ($line.Substring(7,1) -eq "/"))
        $remoteName = $line.split("/")[1]
        $isHEAD     = $line.contains("->")

        if(-not $isRemote){
            $branchName = $line
        } 

        if($isRemote){
            $branchName = $line.split("/")[2..20] -join '/' # TODO: make this suck less
        } 

        if($isHEAD){
            $isHEAD = @{
                LocalRef = $line.split("/")[2]
            }
        }

        [PSCustomObject] @{
            Type       = if($isRemote){"remote"}else{"local"}
            Name       = $branchName
            IsLocal    = (-not $isRemote)
            IsRemote   = $isRemote
            RemoteName = $remoteName
            IsCurrent  = $isCurrent
            IsHEAD     = $isHEAD.LocalRef
            Exists     = $true
        }
    }
}
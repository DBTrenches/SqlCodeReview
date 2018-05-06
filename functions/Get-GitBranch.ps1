function Get-GitBranch {
# TODO: handle for not-same directory repo checks

    (git branch -a).split("`n") | ForEach-Object {
        $line   = $PSItem.Substring(2,($PSItem.Length)-2)
        $isCur  = ($PSItem.Substring(0,1) -eq "*")
        $isRem  = (($line.split("/")[0] -eq "remotes") -and ($line.Substring(7,1) -eq "/"))
        $remNm  = $line.split("/")[1]
        $isHEAD = $line.contains("->")

        if(-not $isRem){
            $bName = $line
        } 

        if($isRem){
            $bName = $line.split("/")[2..20] -join '/' # TODO: make this suck less
        } 

        if($isHEAD){
            $isHEAD = @{
                LocalRef = $line.split("/")[2]
            }
        }

        [PSCustomObject] @{
            Type       = if($isRem){"remote"}else{"local"}
            Name       = $bName
            IsLocal    = (-not $isRem)
            IsRemote   = $isRem
            RemoteName = $remNm
            IsCurrent  = $isCur
            IsHEAD     = $isHEAD.LocalRef
            Exists     = $true
        }
    }
}
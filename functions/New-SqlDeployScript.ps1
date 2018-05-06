function New-SqlDeployScript {
    [CmdletBinding()]Param(
         [string[]]$objList
        ,[string]$branchName
    )
    $repoRoot = (Get-GitRepoRoot)

    $deployScript = ""
    $batchSep = "`r`ngo`r`n"

    $objList | Sort-Object | ForEach-Object {
        $db     = $PSItem.Split(".")[0]
        $schema = $PSItem.Split(".")[1]
        $name   = $PSItem.Split(".")[2]

        $header = "use [$db]$batchSep"

        $content = (Get-Content -Path "$repoRoot/db/$db/$schema/*/$name.sql" -Raw)
        
        $deployScript += "$header$content$batchSep"
    }

    $deployScript | Out-File -FilePath "$repoRoot/log/$branchName.deploy.sql" -Encoding ascii 
}
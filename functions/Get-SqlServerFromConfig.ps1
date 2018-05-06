function Get-SqlServerFromConfig {
    [CmdletBinding()]Param(
         [string]$database
        ,$config
    )

    $repoRoot = (Get-GitRepo).RootFullPath
    if($config -eq $null){
        $config = Get-Content -Path "$repoRoot/config/default.config.csv" -Raw | ConvertFrom-Csv
    }

    if([string]::IsNullOrWhitespace($database)){$database = "*"}

    $srv = $config | Where-Object {$PSItem.Database -eq $database}
    if(($srv | Measure-Object).Count -eq 0){
        $srv = $config | Where-Object {$PSItem.Database -eq "*"}
    }

    $srv | ForEach-Object {
        [PSCustomObject] @{
            Dev  = $PSItem.Dev
            QA   = $PSItem.QA
            Prod = $PSItem.Prod
        }
    }
}

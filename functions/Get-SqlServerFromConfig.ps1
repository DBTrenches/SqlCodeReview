function Get-SqlServerFromConfig {
<#
.DESCRIPTION
    Allow users to pass in a database a retun a list of server targets by environment.
#>
    [CmdletBinding()]Param(
         [string]$database
        ,$config
    )

    if($config -eq $null){
        $configFile = (Get-Content -Path "$((Get-GitRepo).RootFullPath)/config/default.config.json" -Raw | ConvertFrom-Json).EnvironmentConfigFile
        $config = Get-Content -Path $configFile -Raw | ConvertFrom-Csv
    }

    if([string]::IsNullOrWhitespace($database)){$database = "*"}

    $srv = $config | Where-Object {$PSItem.Database -eq $database}
    if(($srv | Measure-Object).Count -eq 0){
        $srv = $config | Where-Object {$PSItem.Database -eq "__DEFAULT__"}
    }

    $srv | ForEach-Object {
        [PSCustomObject] @{
            Dev  = $PSItem.Dev
            QA   = $PSItem.QA
            Prod = $PSItem.Prod
        }
    }
}

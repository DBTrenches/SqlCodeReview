
$script:sqlCodeReview_DefaultModuleConfig = Get-Content $PSScriptRoot\config\default.config.json | ConvertFrom-Json

$serverConfigPath = $sqlCodeReview_DefaultModuleConfig.EnvironmentConfigFile

$script:sqlCodeReview_DefaultServerConfig = Get-Content $serverConfigPath | ConvertFrom-Csv

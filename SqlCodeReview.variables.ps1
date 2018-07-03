
$script:sqlCodeReview_DefaultModuleConfig = Get-Content $PSScriptRoot\config\default.config.json | ConvertFrom-Json
$script:sqlCodeReview_DefaultServerConfig = Get-Content $PSScriptRoot\config\default.config.csv | ConvertFrom-Csv

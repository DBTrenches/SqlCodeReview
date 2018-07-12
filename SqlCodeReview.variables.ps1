
$script:sqlCodeReview_DefaultModuleConfig = Get-Content $PSScriptRoot\config\default.config.json | ConvertFrom-Json

$serverConfigPath = $sqlCodeReview_DefaultModuleConfig.EnvironmentConfigFile

$script:sqlCodeReview_DefaultServerConfig = Get-Content $serverConfigPath | ConvertFrom-Csv

$sqlCodeReview_DefaultModuleConfig.CodeReviewRepo | Get-Member | Where-Object {$_.MemberType -eq "NoteProperty"} | ForEach-Object {
    $project = $_.name
    $objectTypeMap = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.ObjectTypeMap
    $objectConfig = Get-Content $objectTypeMap.FilePath -Raw | ConvertFrom-Csv

    $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.ObjectTypeMap | `
    Add-Member -MemberType NoteProperty -Name "SubFolders" -Value $objectConfig
}

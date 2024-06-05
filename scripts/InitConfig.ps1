Push-Location $PsScriptRoot/..

$ModuleConfigPath = '~/.SqlCodeReview/default.config.json'

New-Item '~/.SqlCodeReview' -ItemType Directory -Force | Out-Null

if($false -eq (Test-Path $ModuleConfigPath)){    
    $DatabaseConfig = Get-Content config/default.config.EXAMPLE.csv  | ConvertFrom-Csv
    $ModuleConfig   = Get-Content config/default.config.EXAMPLE.json | ConvertFrom-Json
    $ModuleConfig.CodeReviewRepo.PSObject.Properties.Remove('MyOtherProject')

    $ModuleConfig | ConvertTo-Json -Depth 5 | Out-File $ModuleConfigPath -Encoding ascii -Force | Out-Null
    $DatabaseConfig | Export-Csv -Path $ModuleConfig.EnvironmentConfigFile -Encoding ascii -Force -NoTypeInformation | Out-Null
}

Pop-Location

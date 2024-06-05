Push-Location $PsScriptroot

. ./scripts/InitConfig.ps1

Get-ChildItem functions | ForEach-Object {
    . $PSItem.FullName
    Export-ModuleMember -Function $PSItem.BaseName
}

. ./scripts/InitVariables.ps1

Pop-Location

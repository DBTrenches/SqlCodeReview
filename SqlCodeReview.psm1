Get-ChildItem "$PSScriptRoot\functions\" | ForEach-Object {
    . $PSItem.FullName
}

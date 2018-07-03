Get-ChildItem "$PSScriptRoot\functions\" | ForEach-Object {
    . $PSItem.FullName
}

. $PSScriptRoot\SqlCodeReview.variables.ps1

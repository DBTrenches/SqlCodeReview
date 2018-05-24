<#
    Manifest File for 'SqlCodeReview'
#>
@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.0.1'
    Author            = 'Peter Vandivier'
    RequiredModules   = @('SQLPS', 'SqlCreateTable')
    FunctionsToExport = @(
        'Get-SqlObjectID'
        'Get-SqlObject'
        'Get-GitRepo'
    )
    CmdletsToExport   = '*'
    VariablesToExport = '*'
}
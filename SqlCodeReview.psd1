<#
    Manifest File for 'SqlCodeReview'
#>
@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.0.1'
    Author            = 'Peter Vandivier'
    RequiredModules   = @('SqlServer', 'SqlCreateTable')
    FunctionsToExport = '*'
    CmdletsToExport   = '*'
    VariablesToExport = '*'
}

<#
    Manifest File for 'SqlCodeReview'
#>
@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.0.1'
    Author            = 'Peter Vandivier'
    RequiredModules   = @('SQLPS', 'SqlCreateTable')
    FunctionsToExport = @(
        'Assert-GitBranch'
        'Enter-GitBranch'
        'Format-SqlObjectList'
        'Get-GitBranch'
        'Get-GitRepo'
        'Get-SqlObject'
        'Get-SqlObjectID'
        'Get-SqlServerFromConfig'
        'New-SqlDeployScript'
        'Request-DBCodeReview'
        'Write-SqlObjectToLocalPath'
        'Write-SqlObjListToLocalPath'
    )
    CmdletsToExport   = '*'
    VariablesToExport = '*'
}
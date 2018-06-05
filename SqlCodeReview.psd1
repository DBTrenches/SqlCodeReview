<#
    Manifest File for 'SqlCodeReview'
#>
@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.0.1'
    Author            = 'Peter Vandivier'
    RequiredModules   = @('SQLPS', 'SqlCreateTable')
    FunctionsToExport = @(
        'Assert-GitBranch.ps1'
        'Enter-GitBranch.ps1'
        'Format-SqlObjectList.ps1'
        'Get-GitBranch.ps1'
        'Get-GitRepo.ps1'
        'Get-SqlObject.ps1'
        'Get-SqlObjectID.ps1'
        'Get-SqlServerFromConfig.ps1'
        'New-SqlDeployScript.ps1'
        'Request-DBCodeReview.ps1'
        'Write-SqlObjectToLocalPath.ps1'
        'Write-SqlObjListToLocalPath.ps1'
    )
    CmdletsToExport   = '*'
    VariablesToExport = '*'
}
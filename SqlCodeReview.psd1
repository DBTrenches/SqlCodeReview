<#
    Manifest File for 'SqlCodeReview'
#>
@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.1.0'
    Guid              = 'b24ec969-6149-405c-926d-ffcbff7412c0'
    Author            = 'Peter Vandivier'
    RequiredModules   = @(
        @{
            ModuleName = 'dbatools'
            ModuleVersion = '2.1.15'
            Guid = '9d139310-ce45-41ce-8e8b-d76335aa1789'
        }, 
        @{
            ModuleName = 'SqlCreateTable'
            ModuleVersion = '0.1.0'
            Guid = 'a4797708-59f5-4489-ad32-d27a3faea894'
        }
    )
    FunctionsToExport = '*'
    CmdletsToExport   = '*'
    VariablesToExport = '*'
}

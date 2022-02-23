@{
    RootModule        = 'SqlCodeReview.psm1'
    ModuleVersion     = '0.0.2'
    Author            = 'Peter Vandivier'
    RequiredModules   = @(
        'SqlServer' 
        @{
            ModuleName = 'SqlCreateTable'
            ModuleVersion = '0.0.2'
            Guid = '15baba57-3dde-4534-bbc7-df7c3fb4a173'
        }
    )
    FunctionsToExport = '*'
    CmdletsToExport   = '*'
    VariablesToExport = '*'
    GUID              = '66ad04aa-83be-4e50-ad22-e385379559ee'
}

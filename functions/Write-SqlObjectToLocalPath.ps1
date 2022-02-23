Function Write-SqlObjectToLocalPath {
<#
    .TODO
        Handle for object deletion/non-existant objects.
        Return submitted object name rather than $null to verbose

#>
    [cmdletbinding()]Param(
        [parameter()]
            [Alias('InstanceName','SqlServer','ServerInstance')]
            [string]$Server
        ,[parameter()]
            [Alias('DatabaseName','dbName')]
            [string]$Database
        ,[parameter()]
            [Alias('SchemaName')]
            [string]$Schema
        ,[parameter()]
            [Alias('ObjectName','Name')]
            [string]$Object
        ,[parameter()]
            [Alias('ObjectType','TypeName')]
            [string]$Type
        ,[parameter()]
            [Alias('ObjectDefinition')]
            [string]$Definition
        ,[parameter(Mandatory)]
            [bool]$Exists
        ,[string]$project = "Default"
    )
    if($Exists){
        $path = Get-SqlObjFilePath `
            -project  $project `
            -database $Database `
            -schema   $Schema `
            -object   $Object `
            -type     $Type

        $fullPath   = $path.fullPath
        $folderPath = $path.folder

        if(-not (Test-Path $folderPath)){
            New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        }
        Write-Verbose "Writing object '$Schema.$Object' to '$fullPath'"
        $Definition | New-Item -ItemType File -Path $fullPath -Force | Out-Null
    }else{
        Write-Verbose "Object '$Schema.$Object' not found at '$Server;$Database'."
        <#if(Test-Path $fullPath){
            Write-Verbose "Attempting deletion of $fullPath."
            Remove-Item -Path $fullPath -Force
        }#>
    }

    #[PSCustomObject]@{
    #    IsOnDisk = Test-Path $fullPath
    #}
}
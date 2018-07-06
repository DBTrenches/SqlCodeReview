Function Write-SqlObjectToLocalPath {
    [cmdletbinding()]Param(
        [parameter(Mandatory=$true)]
            [Alias('InstanceName','SqlServer','ServerInstance')]
            [string]$Server
        ,[parameter(Mandatory=$true)]
            [Alias('DatabaseName','dbName')]
            [string]$Database
        ,[parameter(Mandatory=$true)]
            [Alias('SchemaName')]
            [string]$Schema
        ,[parameter(Mandatory=$true)]
            [Alias('ObjectName','Name')]
            [string]$Object
        ,[parameter(Mandatory=$true)]
            [Alias('ObjectType','TypeName')]
            [string]$Type
        ,[parameter(Mandatory=$true)]
            [Alias('ObjectDefinition')]
            [string]$Definition
        ,[parameter(Mandatory=$true)]
            [bool]$Exists
        ,[string]$project = "Default"
    )

    $path = Get-SqlObjFilePath `
        -project  $project `
        -database $Database `
        -schema   $Schema `
        -object   $Object `
        -type     $Type 

    $fullPath   = $path.fullPath
    $folderPath = $path.folder

    if($Exists){
        if(-not (Test-Path $folderPath)){
            New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        }
        Write-Verbose "Writing object '$Schema.$Object' to '$fullPath'"
        $Definition | New-Item -ItemType File -Path $fullPath -Force | Out-Null
    }else{
        Write-Verbose "Object '$Schema.$Object' not found at '$Server;$Database'."
        if(Test-Path $fullPath){
            Write-Verbose "Attempting deletion of $fullPath."
            Remove-Item -Path $fullPath -Force
        }
    }

    #[PSCustomObject]@{
    #    IsOnDisk = Test-Path $fullPath
    #}
}
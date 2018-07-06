Function Write-SqlObjectToLocalPath {
    [cmdletbinding()]Param(
        [parameter(Mandatory=$true)]
            [Alias('Server','SqlServer','ServerInstance')]
            [string]$InstanceName
        ,[parameter(Mandatory=$true)]
            [Alias('Database','dbName')]
            [string]$DatabaseName
        ,[parameter(Mandatory=$true)]
            [Alias('Schema')]
            [string]$SchemaName
        ,[parameter(Mandatory=$true)]
            [Alias('Object','Name')]
            [string]$ObjectName
        ,[parameter(Mandatory=$true)]
            [Alias('TypeName','Type')]
            [string]$ObjectType
        ,[parameter(Mandatory=$true)]
            [Alias('Definition')]
            [string]$ObjectDefinition
        ,[parameter(Mandatory=$true)]
            [bool]$Exists
        ,[string]$project = "Default"
    )

    $path = Get-SqlObjFilePath `
        -project  $project `
        -Database $DatabaseName `
        -Schema   $SchemaName `
        -Object   $ObjectName `
        -Type     $ObjectType 

    $filePath   = $path.FilePath
    $folderPath = $path.FolderPath

    if($Exists){
        if(-not (Test-Path $folderPath)){
            New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
        }
        Write-Verbose "Writing object '$SchemaName.$ObjectName' to '$filePath'"
        $ObjectDefinition | New-Item -ItemType File -Path $filePath -Force | Out-Null
    }else{
        Write-Verbose "Object '$SchemaName.$ObjectName' not found at '$InstanceName;$DatabaseName'."
        if(Test-Path $filePath){
            Write-Verbose "Attempting deletion of $filePath."
            Remove-Item -Path $filePath -Force
        }
    }

    #[PSCustomObject]@{
    #    IsOnDisk = Test-Path $filePath
    #}
}
Function Write-SqlObjectToLocalPath {
    [cmdletbinding()]Param(
         [parameter(Mandatory=$true)][string]$InstanceName
        ,[parameter(Mandatory=$true)][string]$DatabaseName
        ,[parameter(Mandatory=$true)][string]$SchemaName
        ,[parameter(Mandatory=$true)][string]$ObjectName
        ,[parameter(Mandatory=$true)][string]$ObjectType
        ,[parameter(Mandatory=$true)][string]$ObjectDefinition
        ,[ValidateNotNullOrEmpty()][string]$formatStyle
    )

    $path = Get-SqlObjFilePath `
        -Database $DatabaseName `
        -Schema   $SchemaName `
        -Ob
        -formatStyle 

    $filePath   = $path.FilePath
    #$folderPath = $path.FolderPath

    $ObjectDefinition | New-Item -ItemType File -Path $filePath -Force | Out-Null

    [PSCustomObject]@{
        IsOnDisk = Test-Path $filePath
    }
}
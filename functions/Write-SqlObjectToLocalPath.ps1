Function Write-SqlObjectToLocalPath {
    [cmdletbinding()]Param(
         [string][parameter(Mandatory=$true)]$InstanceName
        ,[string][parameter(Mandatory=$true)]$DatabaseName
        ,[Int32][parameter(Mandatory=$true)]$objectId
    )
    
    $conn = @{
        ServerInstance = $InstanceName
        Database       = $DatabaseName
    }

    $objQ=@"
select 
     def        = object_definition($objectId)
    ,[type]
    ,[type_desc]
    ,base_type  = convert(nchar(2),objectpropertyex($objectId,'BaseType'))
    ,is_table   = convert(bit,iif([type]=N'U',1,0))
    ,id         = $objectId
    ,[database] = db_name()
    ,[schema]   = object_schema_name($objectId)
    ,[name]     = object_name($objectId)
from sys.objects
where [object_id] = $objectId
UNION ALL
select 
     def       = object_definition($objectId)
    ,[type]    = convert(nchar(2),objectpropertyex($objectId,'BaseType'))
    ,[type_desc] = ''
    ,base_type = convert(nchar(2),objectpropertyex($objectId,'BaseType'))
    ,is_table  = convert(bit,iif(convert(nchar(2),objectpropertyex($objectId,'BaseType'))=N'U',1,0))
    ,id        = $objectId
    ,[database] = db_name()
    ,[schema]   = object_schema_name($objectId)
    ,[name]     = object_name($objectId)
where $objectId < 0;
"@
    $2B  = [int64](([math]::Pow(2,31))-1)
    $obj = (Invoke-SqlCmd @conn -Query $objQ -MaxCharLength $2B)
    
    if($obj.is_table){
        $obj.def = (Get-SqlCreateTable @conn -objectId $objectId).createTableCommand
    }
    
# Append batch separator
    $obj.def += "`r`ngo`r`n"  

    $filePath   = (Get-SqlObjFilePath -obj3PartName $obj3PartName -objTypeDesc $obj.type_desc -baseType $obj.base_type)
    $folderPath = $filePath.Replace("$objectName.sql","")

# Ensure folder exists
    if((Test-Path -Path $folderPath) -eq $false) {
        New-Item -Path $folderPath -ItemType Directory -Force | Out-Null
    }
    
    $objDef | New-Item -ItemType File -Path $filePath -Force | Out-Null

    [PSCustomObject]@{
        IsOnDisk = Test-Path $filePath
    }
}
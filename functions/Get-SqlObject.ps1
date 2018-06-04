function Get-SqlObject {
<#
.DESCRIPTION

.TODO
    Permit passing name-only & determining object ID on the fly.
#>
    [CmdletBinding()]Param(
         [Parameter(Mandatory=$true)]
            [Alias('serverName','sqlServer','server')]
            [string]$serverInstance
        ,[Parameter(Mandatory=$true)]
            [Alias('database','dbName')]
            [string]$databaseName
	    ,[Parameter(Mandatory=$true)]
			[Alias('object_id','id','oid','table_id','tableid')]   
	  		[Int32]$objectId
    )

    $conn = @{
        ServerInstance = $serverInstance
        Database       = $databaseName
    }

    $sql_GetObject = @"
select 
     [definition] = object_definition($objectId)
    ,base_type    = convert(nchar(2),objectpropertyex($objectId,'BaseType'))
    ,is_table     = convert(bit,iif(convert(nchar(2),objectpropertyex($objectId,'BaseType'))=N'U',1,0))
    ,[server]     = @@servername
    ,[database]   = db_name()
    ,[schema]     = object_schema_name($objectId)
    ,[name]       = object_name($objectId)
    ,id           = $objectId
"@

    $object = (Invoke-SqlCmd @conn -query $sql_GetObject)

    if($object.is_table){
        $object.definition = (Get-SqlCreateTable @conn -tableId $objectId).createTableCommand
    }

    $object | ForEach-Object {
        [PSCustomObject]@{
            definition = $PSItem.definition
            base_type  = $PSItem.base_type
            is_table   = $PSItem.is_table
            server     = $PSItem.server
            database   = (Get-SqlQuoteNameSparse -text $PSItem.database).text
            schema     = (Get-SqlQuoteNameSparse -text $PSItem.schema).text
            name       = (Get-SqlQuoteNameSparse -text $PSItem.name).text
            id         = $PSItem.id
        }
    }
}
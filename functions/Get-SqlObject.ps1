function Get-SqlObject {
<#
.DESCRIPTION
    Get database-scoped object attributes.

.EXAMPLE
    $wia = @{server=".";dbName="master";schema="dbo";name="sp_WhoIsActive"}
    Get-SqlObject @wia
#>
    [CmdletBinding()]Param(
         [Parameter(Mandatory=$true)]
            [Alias('serverName','sqlServer','serverInstance','sqlInstance')]
            [string]$server
        ,[Parameter(Mandatory=$true)]
            [Alias('databaseName','dbName')]
            [string]$database
        ,[Parameter(Mandatory=$true)]
			[Alias('schemaName')]
            [string]$schema
        ,[Parameter(Mandatory=$true)]
			[Alias('objectName','name')]
            [string]$object
    )

    $conn = @{
        SqlInstance = $server
        Database    = $database
    }

    $objectId = (Get-SqlObjectID @conn -schemaName $schema -objectName $object).id

    $sql_GetObject = @"
select
     [definition] = object_definition($objectId)
    ,base_type    = rtrim(convert(nchar(2),objectpropertyex($objectId,'BaseType')))
    ,is_table     = convert(bit,iif(convert(nchar(2),objectpropertyex($objectId,'BaseType'))=N'U',1,0))
    ,[server]     = @@servername
    ,[database]   = db_name()
    ,[schema]     = object_schema_name($objectId)
    ,[name]       = object_name($objectId)
    ,id           = $objectId
"@

    $dbObject = (Invoke-DbaQuery @conn -query $sql_GetObject -MaxCharLength (2gb-1))

    if($dbObject.is_table){
        $dbObject.definition = (Get-SqlCreateTable @conn -tableId $objectId).createTableCommand
    }

    function isnull{Param($a,$b);if([string]::IsNullOrWhiteSpace($a)){$b}else{$a}}

    $dbObject | ForEach-Object {
        [PSCustomObject]@{
            definition = $PSItem.definition
            base_type  = $PSItem.base_type
            is_table   = $PSItem.is_table
            server     = $PSItem.server
            database   = (Get-SqlQuoteNameSparse -text $PSItem.database).text
            schema     = (Get-SqlQuoteNameSparse -text (isnull $PSItem.schema $schema)).text
            name       = (Get-SqlQuoteNameSparse -text (isnull $PSItem.name $object)).text
            id         = $PSItem.id
            exists     = ($PSItem.id -ne 0)
        }
    }
}
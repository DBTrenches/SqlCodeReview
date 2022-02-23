function Get-SqlObjectID {
<#
.SYNOPSIS
    Given a known exact full name, return db-scoped object id.

.DESCRIPTION
    Returns zero when object is not found so we don't have to handle for System.DBNull

.EXAMPLE
    $wia = @{server=".";dbName="master";schema="dbo";name="sp_WhoIsActive"}
    Get-SqlObjectID @wia
#>
    [CmdletBinding()]Param(
         [Parameter(Mandatory)]
            [Alias('serverName','sqlServer','serverInstance')]
            [string]$server
        ,[Parameter(Mandatory)]
            [Alias('databaseName','dbName')]
            [string]$database
        ,[Parameter(Mandatory)]
			[Alias('schemaName')]
            [string]$schema
        ,[Parameter(Mandatory)]
			[Alias('objectName','name')]
            [string]$object
    )

    $object     = (Get-SqlQuoteNameSparse -text $object).text
    $schema     = (Get-SqlQuoteNameSparse -text $schema).text
    $objectFullName = "$schema.$object"

    $sql_objId = "select [object_id] = isnull(object_id(@object_full_name),0);"
    $conn=new-object data.sqlclient.sqlconnection "Server=$server;Initial Catalog=$database;Integrated Security=True"
    $conn.open()
    $cmd=new-object system.Data.SqlClient.SqlCommand($sql_objId,$conn)
    $cmd.CommandTimeout=1
    [Void]$cmd.Parameters.AddWithValue("@object_full_name",$objectFullName)
    $ds=New-Object system.Data.DataSet
    $da=New-Object system.Data.SqlClient.SqlDataAdapter($cmd)
    $da.fill($ds) | Out-Null
    $conn.Close()
    
    $ds.Tables | ForEach-Object {
        [PSCustomObject] @{
            id = $PSItem.object_id
        }
    }
}
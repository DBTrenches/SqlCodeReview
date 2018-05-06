function Get-SqlObjectID {
    [CmdletBinding()]Param(
         [Parameter(Mandatory=$true)]
            [Alias('serverName','sqlServer','server')]
            [string]$serverInstance
        ,[Parameter(Mandatory=$true)]
            [Alias('database','dbName')]
            [string]$databaseName
        ,[Parameter(Mandatory=$true)]
			[Alias('schema')]
            [string]$schemaName
        ,[Parameter(Mandatory=$true)]
			[Alias('object')]
            [string]$objectName
    )

    $objectName     = (Get-SqlQuoteNameSparse -text $objectName).text
    $schemaName     = (Get-SqlQuoteNameSparse -text $schemaName).text
    $objectFullName = "$schemaName.$objectName"

    $sql_objId = "select [object_id] = isnull(object_id(@object_full_name),0);"
    $conn=new-object data.sqlclient.sqlconnection "Server=$serverInstance;Initial Catalog=$databaseName;Integrated Security=True"
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
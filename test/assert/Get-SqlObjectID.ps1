# assert
$getBaseline = @"
select 
    object_id('dbo.sproc_UnitTest') as sproc_id, 
    object_id('dbo.tbl_UnitTest') as tbl_id;
"@

$connStr = @{
    ServerInstance = "localhost"
    Database       = "tempdb"
}

$baseline = Invoke-SqlCmd @connStr -Query $getBaseline

Describe "Unit test Get-SqlObjectID" {
    It "Stored Proc ID" {
        (Get-SqlObjectID @connStr -objectName "sproc_UnitTest" -schemaName "dbo").id | Should Be $baseline.sproc_id
    }
    It "Table ID" {
        (Get-SqlObjectID @connStr -objectName "tbl_UnitTest" -schemaName "dbo").id | Should Be $baseline.tbl_id
    }
}

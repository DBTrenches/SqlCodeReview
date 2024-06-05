# cleanup
$conn = @{
    Server = "localhost"
    Database = "tempdb"
}

$cleanUp = @"
drop proc if exists dbo.sproc_UnitTest;
drop table if exists dbo.tbl_UnitTest;
"@

Invoke-DbaQuery @conn -query $cleanup
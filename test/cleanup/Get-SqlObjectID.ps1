# cleanup
$conn = @{
    Server = "localhost"
    Database = "tempdb"
}

$cleanUp = @"
drop proc if exists foo;
drop table if exists bar;
"@

Invoke-SqlCmd @conn -query $cleanup
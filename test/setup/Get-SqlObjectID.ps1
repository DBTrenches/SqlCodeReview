# setup
$conn = @{
    Server = "localhost"
    Database = "tempdb"
}

$mkFoo = "create or alter proc foo as return;" 
$mkbar = "create table bar ( i int );"

Invoke-SqlCmd @conn -query $mkFoo
Invoke-SqlCmd @conn -query $mkBar

# setup
$conn = @{
    Server = "localhost"
    Database = "tempdb"
}

$mkTbl  = "$PSScriptRoot\..\sql\tbl_UnitTest.sql"
$mkProc = "$PSScriptRoot\..\sql\sproc_UnitTest.sql"

Invoke-SqlCmd @conn -InputFile $mkTbl
Invoke-SqlCmd @conn -InputFile $mkProc

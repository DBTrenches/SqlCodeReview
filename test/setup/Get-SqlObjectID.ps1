# setup
$conn = @{
    Server = "localhost"
    Database = "tempdb"
}

$mkTbl  = "$PSScriptRoot\..\sql\tbl_UnitTest.sql"
$mkProc = "$PSScriptRoot\..\sql\sproc_UnitTest.sql"

Invoke-DbaQuery @conn -InputFile $mkTbl
Invoke-DbaQuery @conn -InputFile $mkProc

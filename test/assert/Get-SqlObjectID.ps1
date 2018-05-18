# assert
$getBaseline = @"
select 
    object_id('dbo.foo') as foo_id, 
    object_id('dbo.bar') as bar_id;
"@

$connStr = @{
    ServerInstance = "localhost"
    Database       = "tempdb"
}

$baseline = Invoke-SqlCmd @connStr -Query $getBaseline

Describe "Unit testing Get-SqlObjectID" {
    It "Foo ID" {
        (Get-SqlObjectID @connStr -objectName "foo" -schemaName "dbo").id | Should Be $baseline.foo_id
    }
    It "Bar ID" {
        (Get-SqlObjectID @connStr -objectName "bar" -schemaName "dbo").id | Should Be $baseline.bar_id
    }
}

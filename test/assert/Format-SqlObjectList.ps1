
$db1 = "foo"
$sch1 = "bar"
$name1 = "blah"
$obj1 = "$db1.$sch1.$name1"

<#
$db2 = "bork"
$sch2 = ""
$name2 = "bork"
$obj2 = "$db2.$sch2.$name2"
#>
$srv_A = "127.0.0.1"
$srv_B = "localhost"

$config = @"
Database,Prod,QA,Dev
$db1,$srv_B,(local),$srv_A
*,$srv_B,(local),$srv_A
"@ | ConvertFrom-Csv

$res = Format-SqlObjectList -objList @($obj1<#,$obj2#>) -config $config

Describe "Unit testing Format-SqlObjectList" {
    It "Raw Name"{$res.RawName | Should be $obj1}
    It "DB Name"{$res.Database | Should be $db1}
    It "Schema"{$res.Schema    | Should be $sch1}
    It "Obj Name"{$res.Name    | Should be $name1}
    It "Server.Dev" {$res.Server.Dev | Should be $srv_A}
    It "Server.Prod" {$res.Server.Prod | Should be $srv_B}
}
# assert
$getBaseline = @"
select 
     [definition] = object_definition([object_id])
    ,base_type    = convert(nchar(2),objectpropertyex([object_id],'BaseType'))
    ,is_table     = convert(bit,iif(convert(nchar(2),objectpropertyex([object_id],'BaseType'))=N'U',1,0))
    ,[server]     = @@servername
    ,[database]   = db_name()
    ,[schema]     = object_schema_name([object_id])
    ,[name]       = object_name([object_id])
    ,id           = [object_id]
from sys.objects 
where [object_id] in (object_id('dbo.sproc_UnitTest'),object_id('dbo.tbl_UnitTest'))
"@

$connStr = @{
    ServerInstance = "localhost"
    Database       = "tempdb"
}

$baseline = Invoke-DbaQuery @connStr -Query $getBaseline
$sproc_base = $baseline | Where-Object {$PSItem.Name -eq "sproc_UnitTest"}
$tbl_base   = $baseline | Where-Object {$PSItem.Name -eq "tbl_UnitTest"}

$sproc_get = Get-SqlObject @connStr -schemaName "dbo" -objectName "sproc_UnitTest" 
$tbl_get = Get-SqlObject @connStr -schemaName "dbo" -objectName "tbl_UnitTest"


Describe "Get-SqlObject for 'sproc'" {
        #$sproc_get.definition | Should be $sproc_base.definition 
    It "sproc base_type" {$sproc_get.base_type  | Should be $sproc_base.base_type  }
    It "sproc is_table " {$sproc_get.is_table   | Should be $sproc_base.is_table   }
    It "sproc server   " {$sproc_get.server     | Should be $sproc_base.server     }
    It "sproc database " {$sproc_get.database   | Should be $sproc_base.database   }
    It "sproc schema   " {$sproc_get.schema     | Should be $sproc_base.schema     }
    It "sproc name     " {$sproc_get.name       | Should be $sproc_base.name       }
    It "sproc id       " {$sproc_get.id         | Should be $sproc_base.id         }
}

Describe "Get-SqlObject for 'tbl'" {
        #$tbl_get.definition | Should be $tbl_base.definition 
    It "tbl base_type" {$tbl_get.base_type  | Should be $tbl_base.base_type  }
    It "tbl is_table " {$tbl_get.is_table   | Should be $tbl_base.is_table   }
    It "tbl server   " {$tbl_get.server     | Should be $tbl_base.server     }
    It "tbl database " {$tbl_get.database   | Should be $tbl_base.database   }
    It "tbl schema   " {$tbl_get.schema     | Should be $tbl_base.schema     }
    It "tbl name     " {$tbl_get.name       | Should be $tbl_base.name       }
    It "tbl id       " {$tbl_get.id         | Should be $tbl_base.id         }
}



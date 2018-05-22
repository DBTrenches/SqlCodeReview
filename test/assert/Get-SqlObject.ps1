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
where [object_id] in (object_id('dbo.foo'),object_id('dbo.bar'))
"@

$connStr = @{
    ServerInstance = "localhost"
    Database       = "tempdb"
}

$baseline = Invoke-SqlCmd @connStr -Query $getBaseline
$foo_base = $baseline | Where-Object {$PSItem.Name -eq "foo"}
$bar_base = $baseline | Where-Object {$PSItem.Name -eq "bar"}

$foo_get = Get-SqlObject @connStr -objectId $foo_base.id
$bar_get = Get-SqlObject @connStr -objectId $bar_base.id


Describe "Unit testing Get-SqlObject for 'Foo'" {
        #$foo_get.definition | Should be $foo_base.definition 
    It "Foo base_type" {$foo_get.base_type  | Should be $foo_base.base_type  }
    It "Foo is_table " {$foo_get.is_table   | Should be $foo_base.is_table   }
    It "Foo server   " {$foo_get.server     | Should be $foo_base.server     }
    It "Foo database " {$foo_get.database   | Should be $foo_base.database   }
    It "Foo schema   " {$foo_get.schema     | Should be $foo_base.schema     }
    It "Foo name     " {$foo_get.name       | Should be $foo_base.name       }
    It "Foo id       " {$foo_get.id         | Should be $foo_base.id         }
}

Describe "Unit testing Get-SqlObject for 'Bar'" {
        #$bar_get.definition | Should be $bar_base.definition 
    It "Bar base_type" {$bar_get.base_type  | Should be $bar_base.base_type  }
    It "Bar is_table " {$bar_get.is_table   | Should be $bar_base.is_table   }
    It "Bar server   " {$bar_get.server     | Should be $bar_base.server     }
    It "Bar database " {$bar_get.database   | Should be $bar_base.database   }
    It "Bar schema   " {$bar_get.schema     | Should be $bar_base.schema     }
    It "Bar name     " {$bar_get.name       | Should be $bar_base.name       }
    It "Bar id       " {$bar_get.id         | Should be $bar_base.id         }
}



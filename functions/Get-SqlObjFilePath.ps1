function Get-SqlObjFilePath {
<#

.EXAMPLE
    $objs = Format-SqlObjectList -objList @("foo.bar.blah","bork..bork") 
    $objs | Add-Member -Name "Type" -Value "tables" -type noteproperty
    $objs | Get-SqlObjFilePath -PrefixDB -Verbose
    
#>
    [CmdletBinding()]Param(
         [Parameter(ValidateNotNullOrEmpty)]
            $formatStyle = "fmt_Default"
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [string]$Database
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [string]$schema
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [string]$name
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [string]$type
        ,[Switch]$PrefixDB
    )
    Begin {
        $repoRoot = (Get-GitRepo).RootFullPath
    }

    Process {
        $DBPrefix = ""
        if($PrefixDB){$DBPrefix = "/$Database"}

        Switch($formatStyle)
        {
            "fmt_SchemaType" { 
                $filePath   = "$repoRoot$DBPrefix/$schema/$type/$name.sql"
                $folderPath = "$repoRoot$DBPrefix/$schema/$type"
            }
            "fmt_Default"    { 
                $filePath   = "$repoRoot$DBPrefix/$type/$schema.$name.sql"
                $folderPath = "$repoRoot$DBPrefix/$type"
            }
            "fmt_TypeSchema" { 
                $filePath   = "$repoRoot$DBPrefix/$type/$schema/$name.sql"
                $folderPath = "$repoRoot$DBPrefix/$type/$schema"
            }
        }
        
        [PSCustomObject] @{
            FilePath   = $filePath
            folderPath = $folderPath
        }
    }
}
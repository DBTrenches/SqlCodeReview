function Get-SqlObjFilePath {
<#

.EXAMPLE
    $objs = Format-SqlObjectList -objList @("foo.bar.blah","bork..bork") 
    $objs | Add-Member -Name "Type" -Value "tables" -type noteproperty
    $objs | Get-SqlObjFilePath -PrefixDB -Verbose
    
#>
    [CmdletBinding()]Param(
         [Parameter(
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

        [PSCustomObject] @{
            fmt_SchemaType = "$repoRoot$DBPrefix/$schema/$type/$name.sql"
            fmt_Default    = "$repoRoot$DBPrefix/$type/$schema.$name.sql"
            fmt_TypeSchema = "$repoRoot$DBPrefix/$type/$schema/$name.sql"
        }
    }
}
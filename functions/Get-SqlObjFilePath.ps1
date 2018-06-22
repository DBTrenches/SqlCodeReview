function Get-SqlObjFilePath {
<#

#>
    [CmdletBinding()]Param(
        $object
        ,[Switch]$isDatabasePrefixed
    )

    $object | ForEach-Object {
        $dbPrefix = ("","/$($_.Database)")[$isDatabasePrefixed]
        $schema = $_.Schema
        $type   = $_.Type
        $name   = $_.Name

        $fmt_SchemaType = "$dbPrefix/$schema/$type/$name.sql"
        $fmt_Default    = "$dbPrefix/$type/$schema.$name.sql"
        $fmt_TypeSchema = "$dbPrefix/$type/$schema/$name.sql"
    } | ForEach-Object [PSCustomObject] @{
            fmt_SchemaType = $fmt_SchemaType 
            fmt_Default    = $fmt_Default    
            fmt_TypeSchema = $fmt_TypeSchema 
    }
}
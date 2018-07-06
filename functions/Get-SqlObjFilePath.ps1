function Get-SqlObjFilePath {
<#

.EXAMPLE
    $objs = Format-SqlObjectList -objList @("foo.bar.blah","bork..bork") -env prod
    $objs | Add-Member -Name "Type" -Value "tables" -type noteproperty

    $objs | Get-SqlObjFilePath -project "MyOtherProject" -Verbose
    $objs | Get-SqlObjFilePath -Verbose
    
#>
    [CmdletBinding()]Param(
         [string]$project = "default"
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [Alias('DatabaseName','dbName')]
            [string]$Database
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [Alias('SchemaName')]
            [string]$schema
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [Alias('Object','ObjectName')]
            [string]$name
        ,[Parameter(
            ValueFromPipeline=$true,    
            ValueFromPipelineByPropertyName=$true)]
            [Alias('ObjectType','ObjectTypeName')]
            [string]$type
    )
    Begin {
        $formatStyle = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.StyleName
        $nestUnder   = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.NestFilesUnder
        $isPrefixDB  = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.IsDatabasePrefixed
        $repoRoot    = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.LocalPath

        if(-not ([string]::IsNullOrWhiteSpace($nestUnder))){
            $repoRoot += "/$nestUnder"
        }
    }

    Process {
        $DBPrefix = ""
        if($isPrefixDB){$DBPrefix = "/$Database"}

        Switch($formatStyle)
        {
            "fmt_SchemaType" { 
                $file   = "$name.sql"
                $folder = "$repoRoot$DBPrefix/$schema/$type/"
            }
            "fmt_Default"    { 
                $file   = "$schema.$name.sql"
                $folder = "$repoRoot$DBPrefix/$type/"
            }
            "fmt_TypeSchema" { 
                $file   = "$name.sql"
                $folder = "$repoRoot$DBPrefix/$type/$schema/"
            }
        }
        
# if any parts used to construct the folder path have trailing whitespace, trim it here
        while($folder.IndexOf(" /") -ne -1){
            $folder = $folder -Replace(" /","/")
        }
        $fullPath = "$folder$file"

        [PSCustomObject] @{
            file     = $file
            fullPath = $fullPath
            folder   = $folder
        }
    }
}
function Get-SqlObjFilePath {
<#

.EXAMPLE
    $objs = Format-SqlObjectList -objList @("foo.bar.blah","bork..bork") 
    $objs | Add-Member -Name "Type" -Value "tables" -type noteproperty

    $objs | Get-SqlObjFilePath -project "MyOtherProject" -Verbose
    $objs | Get-SqlObjFilePath -Verbose
    
#>
    [CmdletBinding()]Param(
         [string]$project = "default"
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
    )
    Begin {
        $formatStyle = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.StyleName
        $nestUnder   = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.NestFilesUnder
        $isPrefixDB  = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.IsDatabasePrefixed
        $directory   = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.LocalPath

        if(-not ([string]::IsNullOrWhiteSpace($nestUnder))){
            $directory += "/$nestUnder"
        }
    }

    Process {
        $DBPrefix = ""
        if($isPrefixDB){$DBPrefix = "/$Database"}

        Switch($formatStyle)
        {
            "fmt_SchemaType" { 
                $filePath   = "$directory$DBPrefix/$schema/$type/$name.sql"
                $folderPath = "$directory$DBPrefix/$schema/$type"
            }
            "fmt_Default"    { 
                $filePath   = "$directory$DBPrefix/$type/$schema.$name.sql"
                $folderPath = "$directory$DBPrefix/$type"
            }
            "fmt_TypeSchema" { 
                $filePath   = "$directory$DBPrefix/$type/$schema/$name.sql"
                $folderPath = "$directory$DBPrefix/$type/$schema"
            }
        }
        
        [PSCustomObject] @{
            FilePath   = $filePath
            folderPath = $folderPath
        }
    }
}
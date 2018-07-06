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
                $fileName   = "$name.sql"
                $folderPath = "$directory$DBPrefix/$schema/$type/"
            }
            "fmt_Default"    { 
                $fileName   = "$schema.$name.sql"
                $folderPath = "$directory$DBPrefix/$type/"
            }
            "fmt_TypeSchema" { 
                $fileName   = "$name.sql"
                $folderPath = "$directory$DBPrefix/$type/$schema/"
            }
        }
        
        while($folderPath.IndexOf(" /") -ne -1){
            $folderPath = $folderPath -Replace(" /","/")
        }
        $filePath = "$folderPath$fileName"

        [PSCustomObject] @{
            FileName   = $fileName
            FilePath   = $filePath
            FolderPath = $folderPath
        }
    }
}
Function Write-SqlObjListToLocalPath{
<#
.DESCRIPTION
    Takes a well-formatted array of objects from Format-SqlObjectList
    Retrieves & appends the object_id & calls Write-SqlObjectToLocalPath for each
#>
    [cmdletbinding()]Param(
         [parameter(Mandatory=$true)]$objList
        ,[ValidateNotNullOrEmpty()]$project = "Default"
    )

    $repoStyle = @{
        formatStyle = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.StyleName
        nestUnder   = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.NestFilesUnder
        dbPrefix    = $sqlCodeReview_DefaultModuleConfig.CodeReviewRepo.$project.DirectoryFormat.IsDatabasePrefixed
    }

    $objList | ForEach-Object {
        $object = Get-SqlObject @PSItem 
        
        $isOnDisk = (Write-SqlObjectToLocalPath @object @repoStyle).IsOnDisk

        Add-Member -MemberType NoteProperty -Name Object   -Value $obj
        Add-Member -MemberType NoteProperty -Name IsOnDisk -Value $isOnDisk
    }
}

Function Write-SqlObjListToLocalPath{
<#
.DESCRIPTION
    Takes a well-formatted array of objects from Format-SqlObjectList
    Retrieves & appends the object_id & calls Write-SqlObjectToLocalPath for each
#>
    [cmdletbinding()]Param(
         $objList
        ,[Parameter(Mandatory=$true)]
            [ValidateNotNullOrEmpty()]$project = "Default"
    )

    $objList | ForEach-Object {
        $dbObject = Get-SqlObject `
            -server     $_.server `
            -database   $_.database `
            -schema     $_.schema `
            -object     $_.name 

        Write-SqlObjectToLocalPath `
            -server     $_.server `
            -database   $_.database `
            -schema     $_.schema `
            -object     $_.name `
            -type       $dbObject.base_type `
            -definition $dbObject.definition `
            -exists     $dbObject.exists `
            -project    $project
    }
}

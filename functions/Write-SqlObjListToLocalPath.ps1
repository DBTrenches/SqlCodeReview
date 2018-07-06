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

    $objList | ForEach-Object {
        $object = Get-SqlObject `
            -serverInstance $_.Server `
            -databaseName   $_.Database `
            -schemaName     $_.Schema `
            -objectName     $_.Name 

        # $object | 
        Write-SqlObjectToLocalPath `
            -InstanceName   $_.Server `
            -databaseName   $_.Database `
            -schemaName     $_.Schema `
            -objectName     $_.Name `
            -objectType     $object.base_type `
            -Definition     $object.definition `
            -Exists         $object.exists `
            -project $project

        #Add-Member -MemberType NoteProperty -Name Object   -Value $obj
        #Add-Member -MemberType NoteProperty -Name IsOnDisk -Value $isOnDisk
    }
}

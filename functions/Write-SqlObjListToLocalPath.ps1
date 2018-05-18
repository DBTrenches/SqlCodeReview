Function Write-SqlObjListToLocalPath{
<#
    .DESCRIPTION
        Takes a well-formatted array of objects from Format-SqlObjectList
        Retrieves & appends the object_id & calls Write-SqlObjectToLocalPath for each
#>
    [cmdletbinding()]Param(
         [parameter(Mandatory=$true)]$objList
        ,[string]$fromServer
        ,[string]$env
    )

    $objList | ForEach-Object {
        $objId = (Get-SqlObjectID @PSItem -env).ID 
        $obj   = Get-SqlObject @PSItem -objectId $objId
        
        Add-Member -MemberType Property -Name ObjectID -Value $objId
    }

    foreach($o in $objArray){
        $isOnDisk=(Write-SqlObjectToLocalPath `
            -instanceName $fromServer `
            -DatabaseName $o.d `
            -schemaName $o.s `
            -objectName $o.o `
            -env $env)

        $o.isOnDisk = $isOnDisk
    }

    Write-Host "Please see below to validate scripting status for input object(s)"
    $objArray | Format-Table
}
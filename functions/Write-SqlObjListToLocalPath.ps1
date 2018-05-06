Function Write-SqlObjListToLocalPath{
    [cmdletbinding()]Param(
         [parameter(Mandatory=$true)]$objList
        ,[string]$fromServer
        ,[string]$env
    )

    $objList | ForEach-Object {
        $objId = (Get-SqlObjectID @PSItem -env).ID 
        $obj   = Get-SqlObject @PSItem -objectId $objId
        
        Add-Member -MemberType Property -Name ObjectID -Value 0
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
function Get-SqlServerFromConfig {
<#
.DESCRIPTION
    Cache environments for each database in a config file. 
    Set default targets for database: "*". 
    Return a list of server targets by DB name labelled by environment.

.EXAMPLE
    Get-SqlServerFromConfig "foo"
#>
    [CmdletBinding()]Param(
         [string]$database
        ,$config = $sqlCodeReview_DefaultServerConfig
    )

    $srv = $config | Where-Object {$PSItem.Database -eq $database}

    if(($srv | Measure-Object).Count -eq 0){
        Write-Verbose "Database [$database] was not found in your local cache. Update your config file to suppress this message."
        $srv = $config | Where-Object {$PSItem.Database -eq "*"} # default
    }

    if(($srv | Measure-Object).Count -eq 0){
        Write-Warning "Cached server parsing failed. You may need to add a default server to the config."
    }

    $srv | ForEach-Object {
        [PSCustomObject] @{
            Dev  = $PSItem.Dev
            QA   = $PSItem.QA
            Prod = $PSItem.Prod
        }
    }
}

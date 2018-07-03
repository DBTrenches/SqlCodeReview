function Get-SqlServerFromConfig {
<#
.DESCRIPTION
    Allow users to pass in a database a retun a list of server targets by environment.
    Currently only operable from inside a git repo WITH a config file -_-...

.EXAMPLE
    Get-SqlServerFromConfig "foo"

.TODO
    Remove dependency on git repo.

#>
    [CmdletBinding()]Param(
         [string]$database
        ,$config
    )

    try {
        if($config -eq $null){
            $config = $sqlCodeReview_DefaultServerConfig
        }
    }
    catch {
        Write-Warning "Server config cache failed."
    }

    if([string]::IsNullOrWhitespace($database)){$database = "*"}

    $srv = $config | Where-Object {$PSItem.Database -eq $database}
    if(($srv | Measure-Object).Count -eq 0){
        $srv = $config | Where-Object {$PSItem.Database -eq "*"}
    }

    if(($srv | Measure-Object).Count -eq 0){
        Write-Warning "Cached server parsing failed for database [$database]. You may need to add a default server to the config."
    }

    $srv | ForEach-Object {
        [PSCustomObject] @{
            Dev  = $PSItem.Dev
            QA   = $PSItem.QA
            Prod = $PSItem.Prod
        }
    }
}

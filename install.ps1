#Requires -RunAsAdministrator 

$Disclaimer = "I am a lazy person"
$Disclaimer | clip # backspace to remove the linefeed from the console if pasting

$Acknowledgement = Read-Host "Type the following text in order to proceed: '$Disclaimer'"

If($Acknowledgement -eq $Disclaimer){

    $CurrentRepoRoot = "$PSScriptRoot"

    Push-Location

    $ModuleDirectory = "$home\Documents\WindowsPowerShell\Modules"
    if(-not (Test-Path $ModuleDirectory)){
        Write-Warning "Creating PSModulePath target at '$ModuleDirectory'."
        New-Item -ItemType Directory -Path $ModuleDirectory | Out-Null
    }
    Set-Location $ModuleDirectory

    if(-not (Test-Path SqlCodeReview)){
        Write-Warning "Downloading SqlCodeReview"
        git clone https://github.com/petervandivier/SqlCodeReview.git
    }

    if(-not (Test-Path SqlCreateTable)){
        Write-Warning "Downloading SqlCreateTable"
        git clone https://github.com/petervandivier/SqlCreateTable.git
    }

    if($null -ne (Get-Module SQLPS -ListAvailable)){
        Write-Warning "Removing SQLPS Module"
        Remove-Module SQLPS -Force -ErrorAction SilentlyContinue
    }

    if($null -eq (Get-Module SqlServer -ListAvailable)){
        Write-Warning "Downloading SqlServer Module"
        Install-Module SqlServer -Force -ErrorAction SilentlyContinue 
    }

    $DatabaseConfig = Get-Content "$CurrentRepoRoot/config/default.config.EXAMPLE.csv"  | ConvertFrom-Csv
    $ModuleConfig   = Get-Content "$CurrentRepoRoot/config/default.config.EXAMPLE.json" | ConvertFrom-Json
    $ModuleConfig.CodeReviewRepo.PSObject.Properties.Remove('MyOtherProject')

    $ModuleConfig | ConvertTo-Json | Out-File $ModuleConfigPath -Encoding ascii -Force | Out-Null
    $DatabaseConfig | Export-Csv -Path $ModuleConfig.EnvironmentConfigFile -Encoding ascii -Force -NoTypeInformation | Out-Null

    Import-Module SqlCodeReview -Scope Global -Force 
    
    if(-not (test-path $profile.CurrentUserAllHosts)){
        New-Item -type file -path $Profile.CurrentUserAllHosts -force | Out-Null
    }
    
    $myProfile = Get-Content $Profile.CurrentUserAllHosts -Raw
    
    if($myProfile -notlike "*SqlCodeReview*"){
        Add-Content -Path $Profile.CurrentUserAllHosts -Value "Import-Module SqlCodeReview"
    }

    Pop-Location
}
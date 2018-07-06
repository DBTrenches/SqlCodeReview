Push-Location
Set-Location $PSScriptRoot\..
try {    
    Import-Module .\SqlCodeReview.psd1 -Force
    $go = $true
}
catch {
    Write-Warning "Error re-importing module. Tests will not be run."
    $go = $false
}

if($go){
    Set-Location $PSScriptRoot
    
    $setup   = Get-ChildItem ".\setup\*.ps1" 
    $assert  = Get-ChildItem ".\assert\*.ps1" 
    $cleanup = Get-ChildItem ".\cleanup\*.ps1" 
    
    $setup   | % {. ".\setup\$($_.Name)"} 
    $assert  | % {. ".\assert\$($_.Name)"} 
    $cleanup | % {. ".\cleanup\$($_.Name)"} 
}    
Pop-Location
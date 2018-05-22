Set-Location "$((Get-GitRepo).RootFullPath)\test"

$setup   = Get-ChildItem ".\setup\*.ps1" 
$assert  = Get-ChildItem ".\assert\*.ps1" 
$cleanup = Get-ChildItem ".\cleanup\*.ps1" 

$setup   | % {. ".\setup\$($_.Name)"} 
$assert  | % {. ".\assert\$($_.Name)"} 
$cleanup | % {. ".\cleanup\$($_.Name)"} 


# setup test

New-Item -ItemType Directory -Name "GetGitRepo" | Out-Null
Set-Location -Path "./GetGitRepo"
if((Get-Location).Path.EndsWith("GetGitRepo")){ 
    git init | Out-Null 
    New-Item -Name "readme.md" | Out-Null
    git add .
    git commit -m "init commit" | Out-Null
    Set-Location ".."
}

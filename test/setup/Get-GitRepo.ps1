# setup test
# TODO: https://github.com/pester/Pester/wiki/TestDrive
#   so that mid-test aborts don't leave garbage in the filesystem

New-Item -ItemType Directory -Name "GetGitRepo" | Out-Null
Set-Location -Path "./GetGitRepo"
if((Get-Location).Path.EndsWith("GetGitRepo")){ 
    git init | Out-Null 
    New-Item -Name "readme.md" | Out-Null
    git add .
    git commit -m "init commit" | Out-Null
    Set-Location ".."
}

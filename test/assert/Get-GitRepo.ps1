# assert test
# this repo is local ONLY so suppress some errors

$repo = Get-GitRepo -dir "./GetGitRepo" -ErrorAction SilentlyContinue

Describe "Get-GitRepo" {
    It "RootFullPath " { Test-Path($repo.RootFullPath) | Should -BeTrue }
    It "CurrentBranch" { $repo.CurrentBranch | Should be "master" }
    It "IsRepo       " { $repo.IsRepo        | Should -BeTrue     }
    It "RemoteURL    " { $repo.RemoteURL     | Should -BeNullOrEmpty }
    It "IsSsh        " { $repo.IsSsh         | Should -BeFalse    }
    It "Provider     " { $repo.Provider      | Should be $null    }
}

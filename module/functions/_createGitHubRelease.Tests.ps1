# <copyright file="_createGitHubRelease.Tests.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

BeforeAll {
    # sut
    . $PSCommandPath.Replace('.Tests.ps1', '.ps1')

    # Stand-ins for the commands the function uses at build time. 'exec' behaves like InvokeBuild's: it runs the
    # command and throws when the command sets a non-zero exit code. 'gh' is the GitHub CLI, which is mocked.
    function exec {
        param([scriptblock] $Command)
        $global:LASTEXITCODE = 0
        & $Command
        if ($global:LASTEXITCODE -ne 0) { throw "Command exited with code $global:LASTEXITCODE." }
    }
    function gh {}
}

Describe '_createGitHubRelease' {

    BeforeEach {
        $script:GitHubReleaseDryRunMode = $false
        Mock gh {}
        Mock Write-Host {}
    }

    It 'requires a tag' {
        (Get-Command _createGitHubRelease).Parameters['Tag'].Attributes.Mandatory | Should -Contain $true
    }

    Context 'When dry run mode is off' {

        It 'creates a release for the tag, with generated release notes' {
            _createGitHubRelease -Tag '1.2.3'

            Should -Invoke gh -Times 1 -Exactly -ParameterFilter {
                ($args -join ' ') -eq 'release create 1.2.3 --generate-notes'
            }
        }

        It 'throws when the GitHub CLI fails' {
            Mock gh { $global:LASTEXITCODE = 1 }

            { _createGitHubRelease -Tag '1.2.3' } | Should -Throw '*exited with code 1*'
        }
    }

    Context 'When dry run mode is on' {

        BeforeEach {
            $script:GitHubReleaseDryRunMode = $true
        }

        It 'does not call the GitHub CLI' {
            _createGitHubRelease -Tag '1.2.3'

            Should -Invoke gh -Times 0 -Exactly
        }

        It 'reports that the release was skipped' {
            _createGitHubRelease -Tag '1.2.3'

            Should -Invoke Write-Host -Times 1 -Exactly -ParameterFilter {
                $Object -like '*Skipped due to GitHubReleaseDryRunMode=True*'
            }
        }
    }
}

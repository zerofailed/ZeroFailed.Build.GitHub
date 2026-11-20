# <copyright file="_uploadReleaseArtifact.Tests.ps1" company="Endjin Limited">
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

Describe '_uploadReleaseArtifact' {

    BeforeEach {
        $script:GitHubReleaseDryRunMode = $false
        $script:artefactPath = Join-Path $TestDrive 'MyPackage.1.2.3.nupkg'
        Set-Content -Path $script:artefactPath -Value 'package'
        Mock gh {}
        Mock Write-Host {}
    }

    Context 'Validation' {

        It 'requires an item and a tag' {
            $parameters = (Get-Command _uploadReleaseArtifact).Parameters
            $parameters['Item'].Attributes.Mandatory | Should -Contain $true
            $parameters['Tag'].Attributes.Mandatory | Should -Contain $true
        }

        It 'throws when the item does not exist, without calling the GitHub CLI' {
            $missingPath = Join-Path $TestDrive 'missing.nupkg'

            { _uploadReleaseArtifact -Item $missingPath -Tag '1.2.3' } | Should -Throw '*Item*'
            Should -Invoke gh -Times 0 -Exactly
        }
    }

    Context 'When dry run mode is off' {

        It 'uploads the item to the release for the tag, replacing any existing asset' {
            _uploadReleaseArtifact -Item $script:artefactPath -Tag '1.2.3'

            Should -Invoke gh -Times 1 -Exactly -ParameterFilter {
                ($args -join ' ') -eq "release upload --clobber 1.2.3 $($script:artefactPath)"
            }
        }

        It 'throws when the GitHub CLI fails' {
            Mock gh { $global:LASTEXITCODE = 1 }

            { _uploadReleaseArtifact -Item $script:artefactPath -Tag '1.2.3' } | Should -Throw '*exited with code 1*'
        }
    }

    Context 'When dry run mode is on' {

        BeforeEach {
            $script:GitHubReleaseDryRunMode = $true
        }

        It 'does not call the GitHub CLI' {
            _uploadReleaseArtifact -Item $script:artefactPath -Tag '1.2.3'

            Should -Invoke gh -Times 0 -Exactly
        }

        It 'reports that the upload was skipped' {
            _uploadReleaseArtifact -Item $script:artefactPath -Tag '1.2.3'

            Should -Invoke Write-Host -Times 1 -Exactly -ParameterFilter {
                $Object -like '*Skipped due to GitHubReleaseDryRunMode=True*'
            }
        }
    }
}

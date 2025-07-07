# <copyright file="_createGitHubRelease.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
  Creates a GitHub release named using the running build's version number.

.DESCRIPTION
  Uses the GitHub CLI to create a release in the GitHub repository associated with the local repo. Requires the
  GitHub CLI to be installed and logged-in as an identity with contributor permissions to the GitHub repository.

.EXAMPLE
  _createGitHubRelease
#>
function _createGitHubRelease
{
    [CmdletBinding()]
    param (
      [Parameter(Mandatory=$true)]
      [string] $Tag
    )

    if (!$GitHubReleaseDryRunMode) {
        exec { & gh release create $Tag --generate-notes }
    }
    else {
        Write-Host "  Skipped due to GitHubReleaseDryRunMode=True"
    }
}
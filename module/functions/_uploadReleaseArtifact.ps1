# <copyright file="_uploadReleaseArtifact.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

<#
.SYNOPSIS
  Uploads an item as a GitHub release asset.

.DESCRIPTION
  Uses the GitHub CLI to upload & attach an existing file as a GitHub release asset. The release is identified
  using the running build's version number. Requires the GitHub CLI to be installed and logged-in as an identity
  with contributor permissions to the GitHub repository.

.EXAMPLE
  _uploadReleaseArtifact -Item <path-to-release asset>
#>
function _uploadReleaseArtifact
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateScript({Test-Path $_})]
        [string] $Item,

        [Parameter(Mandatory=$true)]
        [string] $Tag
    )
    
    if (!$GitHubReleaseDryRunMode) {
        exec { & gh release upload --clobber $Tag $Item }
    }
    else {
        Write-Host "  Skipped due to GitHubReleaseDryRunMode=True"
    }
}
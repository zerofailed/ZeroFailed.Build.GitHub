# <copyright file="release.properties.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: When true, a GitHub release will be created with the current version number
$CreateGitHubRelease = -not [Convert]::ToBoolean((property ZF_GITHUB_SKIP_CREATE_RELEASE $false))

# Synopsis: When true, a GitHub release will not be created. Used by the internal Pester tests.
$GitHubReleaseDryRunMode = [Convert]::ToBoolean((property ZF_GITHUB_RELEASE_DRY_RUN_MODE $false))

# Synopsis: An array of paths to files that will be included as GitHub release assets. NOTE: NuGet packages do not need to be included in this list, as they will be handled automatically.
$GitHubReleaseArtefacts = @()

# Synopsis: When true, any published NuGet packages will also be treated as GitHub release assets
$PublishNuGetPackagesAsGitHubReleaseArtefacts = [Convert]::ToBoolean((property ZF_GITHUB_RELEASE_INCLUDE_NUGET_PACKAGES $false))

# Synopsis: Name of the file used to record the set of files added as GitHub release artifacts
$GitHubReleaseArtefactsManifestFilePath = "github-release-artefacts.log"
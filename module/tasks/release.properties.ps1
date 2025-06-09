# <copyright file="release.properties.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: When true, a GitHub release will be created with the current version number
$CreateGitHubRelease = $false

# Synopsis: When true, a GitHub release will not be created. Used by the internal Pester tests.
$GitHubReleaseDryRunMode = $false

# Synopsis: An array of paths to files that will be included as GitHub release assets. NOTE: NuGet packages do not need to be included in this list, as they will be handled automatically.
$GitHubReleaseArtefacts = @()

# Synopsis: When true, any published NuGet packages will also be treated as GitHub release assets
$PublishNuGetPackagesAsGitHubReleaseArtefacts = $false

# Synopsis: Name of the file used to store the set of files added as GitHub release artifacts
$GitHubReleaseArtefactsManifestFilePath = "github-release-artefacts.log"
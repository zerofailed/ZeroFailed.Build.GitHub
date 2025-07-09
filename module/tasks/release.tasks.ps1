# <copyright file="release.tasks.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

. $PSScriptRoot/release.properties.ps1

# Synopsis: 
task PublishGitHubRelease -If { $CreateGitHubRelease } -After PublishCore Init,EnsureGitHubCli,Version,{

    if ($PublishNuGetPackagesAsGitHubReleaseArtefacts) {
        # Evaluate the NuGet packages that need to be included in the GitHub release.        
        # This property is set by the ZeroFailed.Build.DotNet extension, which we expect to
        # be using since we're building NuGet packages, but we'll handle setting the default
        # in the event that it isn't being used.
        $NugetPackageNamesToPublishGlob ??= { "*.{0}.nupkg" -f $script:GitVersion.SemVer }

        # By default, we use a glob that includes the current version number which avoids
        # including previously built packages.  However, the version details won't
        # be known on initialisation; therefore this needs to support deferred evaluation.
        $evaluatedNugetPackagesToPublishGlob = Resolve-Value $NugetPackageNamesToPublishGlob
        Write-Build White "evaluatedNugetPackagesToPublishGlob: $evaluatedNugetPackagesToPublishGlob"

        # Now use that glob pattern to find the NuGet files to be included
        $nugetPackagesToPublish = Get-ChildItem -Path $PackagesDir -Filter $evaluatedNugetPackagesToPublishGlob
        Write-Build White "nugetPackagesToPublish:`n`t$($nugetPackagesToPublish.Name -join "`n`t")"
        
        # Update list of GitHub release artefacts to include resolved NuGet packages
        $script:GitHubReleaseArtefacts += $nugetPackagesToPublish.FullName
        Write-Host "GitHubReleaseArtefacts:`n`t$($GitHubReleaseArtefacts -join "`n`t")"
    }

    $existingRelease = exec { gh release list } |
                            ConvertFrom-Csv -Delimiter "`t" -Header @("TITLE","TYPE","TAG NAME","PUBLISHED") |
                            Where-Object { $_."TAG NAME" -eq $GitVersion.SemVer }

    if (!$existingRelease) {
        Write-Host "Creating new GitHub release: $($GitVersion.SemVer)"
        _createGitHubRelease -Tag $GitVersion.SemVer
    }
    else {
        Write-Host "Updating existing GitHub release: $($GitVersion.SemVer)"
    }

    if ($GitHubReleaseArtefacts) {
        Set-Content -Path $GitHubReleaseArtefactsManifestFilePath -Value "" -NoNewline
        foreach ($releaseArtefact in $GitHubReleaseArtefacts) {
            if (Test-Path $releaseArtefact) {
                Write-Host "Uploading release artefact: $(Split-Path -Leaf $releaseArtefact)"
                Add-Content -Path $GitHubReleaseArtefactsManifestFilePath -Value $releaseArtefact
                _uploadReleaseArtifact -Item $releaseArtefact -Tag $GitVersion.SemVer
            }
            else {
                Write-Warning "GitHub Release artefact not found, skipping: $releaseArtefact"
            }
        }
    }
}
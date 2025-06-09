# <copyright file="release.tasks.ps1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>

# Synopsis: 
task PublishGitHubRelease -If { $CreateGitHubRelease } -After PublishCore Init,EnsureGitHubCli,Version,{

    if ($PublishNuGetPackagesAsGitHubReleaseArtefacts) {
        # Evaluate the NuGet packages that need to be included in the GitHub release
        $evaluatedNugetPackagesToPublishGlob = Invoke-Expression "`"$($NugetPackageNamesToPublishGlob)$($NugetPackagesToPublishGlobSuffix)`""
        Write-Host "evaluatedNugetPackagesToPublishGlob: $evaluatedNugetPackagesToPublishGlob"
        $nugetPackagesToPublish = Get-ChildItem -Path "$here/_packages" -Filter $evaluatedNugetPackagesToPublishGlob
        Write-Host "nugetPackagesToPublish: $nugetPackagesToPublish"
        
        # Update list of GitHub release artefacts to include resolved NuGet packages
        $script:GitHubReleaseArtefacts += $nugetPackagesToPublish
        Write-Host "GitHubReleaseArtefacts: $GitHubReleaseArtefacts"
    }


    $existingRelease = exec { gh release list } |
                            ConvertFrom-Csv -Delimiter "`t" -Header @("TITLE","TYPE","TAG NAME","PUBLISHED") |
                            Where-Object { $_."TAG NAME" -eq $GitVersion.SemVer }

    if (!$existingRelease) {
        Write-Host "Creating new GitHub release: $($GitVersion.SemVer)"
        _createGitHubRelease
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
                _uploadReleaseArtifact $releaseArtefact    
            }
            else {
                Write-Warning "GitHub Release artefact not found, skipping: $releaseArtefact"
            }
        }
    }
}
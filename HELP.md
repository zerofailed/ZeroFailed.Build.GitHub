# ZeroFailed.Build.GitHub - Reference Sheet

<!-- START_GENERATED_HELP -->

## Release

This group contains functionality for working with GitHub Releases.

### Properties

| Name                                           | Default Value                  | ENV Override                               | Description                                                                                                                                                                     |
| ---------------------------------------------- | ------------------------------ | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `CreateGitHubRelease`                          | $false                         | `ZF_GITHUB_SKIP_CREATE_RELEASE`            | When true, a GitHub release will be created with the current version number                                                                                                     |
| `GitHubReleaseArtefacts`                       | @()                            |                                            | An array of paths to files that will be included as GitHub release assets. NOTE: NuGet packages do not need to be included in this list, as they will be handled automatically. |
| `GitHubReleaseArtefactsManifestFilePath`       | "github-release-artefacts.log" |                                            | Name of the file used to record the set of files added as GitHub release artifacts                                                                                              |
| `GitHubReleaseDryRunMode`                      | $false                         | `ZF_GITHUB_RELEASE_DRY_RUN_MODE`           | When true, a GitHub release will not be created. Used by the internal Pester tests.                                                                                             |
| `PublishNuGetPackagesAsGitHubReleaseArtefacts` | $false                         | `ZF_GITHUB_RELEASE_INCLUDE_NUGET_PACKAGES` | When true, any published NuGet packages will also be treated as GitHub release assets                                                                                           |

### Tasks

| Name                   | Description                                                                     |
| ---------------------- | ------------------------------------------------------------------------------- |
| `PublishGitHubRelease` | Create or updates a GitHub release and attaches artifacts (e.g. NuGet packages) |


<!-- END_GENERATED_HELP -->

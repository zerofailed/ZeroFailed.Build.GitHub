# ZeroFailed.Build.GitHub

[![Build Status](https://github.com/zerofailed/ZeroFailed.Build.GitHub/actions/workflows/build.yml/badge.svg)](https://github.com/zerofailed/ZeroFailed.Build.GitHub/actions/workflows/build.yml)  
[![GitHub Release](https://img.shields.io/github/release/zerofailed/ZeroFailed.Build.GitHub.svg)](https://github.com/zerofailed/ZeroFailed.Build.GitHub/releases)  
[![PowerShell Gallery Version](https://img.shields.io/powershellgallery/v/Endjin.ZeroFailed.Build?color=blue)](https://www.powershellgallery.com/packages/ZeroFailed.Build.GitHub)  
[![License](https://img.shields.io/github/license/zerofailed/ZeroFailed.Build.GitHub.svg)](https://github.com/zerofailed/ZeroFailed.Build.GitHub/blob/main/LICENSE)

A [ZeroFailed](https://github.com/endjin/ZeroFailed) extension containing features that support build process integration with GitHub.

## Features Overview

| Component Type | Included | Notes               |
|----------------|----------|---------------------|
| Tasks          | yes      | |
| Functions      | yes      | |
| Processes      | no       | Designed to be compatible with the default process provided by the [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common) extension |

For more information about the different component types, please refer to the [ZeroFailed documentation](https://github.com/endjin/ZeroFailed/blob/main/README.md#extensions).

This extension consists of the following feature groups, refer to the [HELP page](./HELP.md) for more details.

- Releases

The diagram below shows the discrete features and when they run as part of the default build process provided by [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common).

```mermaid
kanban
    init
    version
    build
    test
    analysis
    package
    publish
        release[Create GitHub Release]
```

## Pre-Requisites

Using this extension requires the following components to be installed:

- [GitHub CLI](https://cli.github.com/)

## Dependencies

The following ZeroFailed extensions will be installed when using this extension.

| Extension                                                                        | Reference Type | Version |
| -------------------------------------------------------------------------------- | -------------- | ------- |
| [ZeroFailed.Build.Common](https://github.com/zerofailed/ZeroFailed.Build.Common) | git            | `main`  |

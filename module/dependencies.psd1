# <copyright file="dependencies.psd1" company="Endjin Limited">
# Copyright (c) Endjin Limited. All rights reserved.
# </copyright>
@(
    @{
        # Assume latest stable version
        Name = "ZeroFailed.Build.Common"
        Process = "tasks/build.process.ps1"
        GitRepository = "https://github.com/zerofailed/ZeroFailed.Build.Common"
    }
)
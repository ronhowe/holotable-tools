
<#
    .SYNOPSIS
    This script copies local Holotable repo files to the installed Holotable client location.

    .DESCRIPTION
    This script copies local Holotable repo files to the installed Holotable client location.

    .PARAMETER $RepoPath
    The path to the local Holotable repo.

    .PARAMETER $IncludeImages
    Whether or not to copy the image files.
#>
[CmdletBinding()]
param(
    [string]
    $RepoPath = "~/source/repos/holotable",

    [bool]
    $IncludeImages = $false
)

if (-not (Test-Path -Path $RepoPath)) {
    Write-Error "Cannot find $RepoPath." -ErrorAction Stop
}

if (-not (Test-Path -Path $env:HOLOTABLE_PATH)) {
    Write-Error "Cannot find HOLOTABLE_PATH environment variable or path." -ErrorAction Stop
}

Copy-Item -Path (Join-Path -Path $RepoPath -ChildPath "*.cdf") -Destination $env:HOLOTABLE_PATH -Force -PassThru

# Only needed if file hashes are incorrect.
if ($IncludeImages) {
    Copy-Item -Path (Join-Path -Path $RepoPath -ChildPath "Images-HT/starwars") -Destination (Join-Path -Path $env:HOLOTABLE_PATH -ChildPath "cards") -Recurse -Force -PassThru
}

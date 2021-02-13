function SortAndSave () {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $CdfInputPath,

        [Parameter()]
        [string]
        $CdfOutputPath
    )

    if (Test-Path -Path $CdfOutputPath) {
        Remove-Item $CdfOutputPath -Force
    }

    if (Test-Path -Path $CdfInputPath) {
        Get-Content -Path $CdfInputPath |
        Where-Object {
            ($_.StartsWith("card"))
        } |
        Sort-Object |
        Add-Content -Path $CdfOutputPath
    }
    else {
        Write-Host "Could not find $CdfInputPath"
    }
}

SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Dark.sorted.cdf"
SortAndSave -CdfInputPath "~/source/repos/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/darkside.sorted.cdf"

SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Light.sorted.cdf"
SortAndSave -CdfInputPath "~/source/repos/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/lightside.sorted.cdf"

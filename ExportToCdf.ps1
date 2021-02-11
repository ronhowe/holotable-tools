$ErrorActionPreference = "Stop"
function ExportToCdf {
    <#
    .SYNOPSIS
    This script attempts to parse a JSON file in the swccg-card-json repo to the approximate format of a Holotable CDF file.

    .DESCRIPTION
    This script attempts to parse a JSON file in the swccg-card-json repo to the approximate format of a Holotable CDF file.

    The resulting output is sorted by card type, subtype and title.

    .PARAMETER JsonPath
    The path to the input JSON file.

    .PARAMETER CdfPath
    The path to the output CDF file.

    .PARAMETER Id
    The id to parse.  Valid values can be found in the input JSFON file "id" properties.

    .PARAMETER Set
    The set to parse.  Valid values can be found in the input JSFON file "set" properties.

    .EXAMPLE
    PS> ./ExportToCdf.ps1 -JsonPath "./Dark.json" -CdfPath "./Dark.cdf" -Set "Virtual Set 13" -Verbose

    .EXAMPLE
    PS> ./ExportToCdf.ps1 -JsonPath "./Light.json" -CdfPath "./Light.cdf" -Id 5300 -Verbose
#>
    [CmdletBinding(DefaultParameterSetName = "NoFilter")]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "NoFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "IdFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "SetFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $JsonPath,

        [Parameter(Mandatory = $true, ParameterSetName = "NoFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "IdFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "SetFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $CdfPath,

        [Parameter(Mandatory = $true, ParameterSetName = "IdFilter")]
        [ValidateNotNull()]
        [int]
        $IdFilter,

        [Parameter(Mandatory = $true, ParameterSetName = "SetFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $SetFilter,

        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $TypeFilter,

        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $TitleFilter
    )

    if (-not (Test-Path -Path $JsonPath)) {
        Write-Error "Cannot find $JsonPath." -ErrorAction Stop
    }

    if (Test-Path -Path $CdfPath) {
        Remove-Item -Path $CdfPath
    }

    # $version = "version {0}" -f $(Get-Date -Format "yyyyMMdd")
    # Add-Content -Path $CdfPath -Value $version
    # $back = "back foo.gif"
    # Add-Content -Path $CdfPath -Value $back

    [string]$PreviousSection = ""
    $PreviousSection | Out-Null

    $json = Get-Content -Path $JsonPath | ConvertFrom-Json

    $json |
    Select-Object -ExpandProperty "cards" |
    # Where-Object {
    # $_.id -eq 634
    # if ($PSCmdlet.ParameterSetName -eq "NoFilter") {
    #     $true
    # }
    # elseif ($PSCmdlet.ParameterSetName -eq "IdFilter") {
    #     $_.id -eq $IdFilter
    # }
    # elseif ($PSCmdlet.ParameterSetName -eq "SetFilter") {
    #     $_.set -like $SetFilter
    # }
    # elseif ($PSCmdlet.ParameterSetName -eq "TitleFilter") {
    #     $_.front.title -like $TitleFilter
    # }
    # elseif ($PSCmdlet.ParameterSetName -eq "TypeFilter") {
    #     $_.front.type -like $TypeFilter
    # }
    # } |
    Select-Object -Property @{Name = "Section"; Expression = { ConvertTo-CdfSection -Context $_ } }, @{Name = "SortTitle"; Expression = { ConvertTo-CdfTitleSort -Context $_ } }, @{Name = "Line"; Expression = { ConvertTo-CdfLine -Context $_ } } |
    Sort-Object -Property "Section", "SortTitle", "Line" |
    ForEach-Object {
        if ($PreviousSection -ne $_.Section) {
            Write-Output $("`n`{0}`n" -f $_.Section)
        }
        $PreviousSection = $_.Section
        Write-Output $_.Line
    } |
    Add-Content -Path $CdfPath
}

Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf"
# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" # -Debug -Verbose

ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -IdFilter 3 -Debug -Verbose
# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -IdFilter 5300 # -Debug -Verbose

# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -SetFilter "*Dagobah*"
# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -SetFilter "*13*" # -Debug -Verbose

# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TitleFilter "*Rebel Leadership*" # -Debug -Verbose
# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TitleFilter "*Rebel Leadership*" # -Debug -Verbose

# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TypeFilter "Admiral*" # -Debug -Verbose
# ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TypeFilter "Creature" # -Debug -Verbose

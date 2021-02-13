function ConvertTo-Cdf {
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
    PS> ./ConvertTo-Cdf.ps1 -JsonPath "./Dark.json" -CdfPath "./Dark.cdf" -Set "Virtual Set 13" -Verbose

    .EXAMPLE
    PS> ./ConvertTo-Cdf.ps1 -JsonPath "./Light.json" -CdfPath "./Light.cdf" -Id 5300 -Verbose
#>
    [CmdletBinding(DefaultParameterSetName = "NoFilter")]
    param(
        [Parameter(Mandatory = $true, ParameterSetName = "NoFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "IdFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "SetFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $JsonPath,

        [Parameter(Mandatory = $true, ParameterSetName = "NoFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "IdFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "SetFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
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

        [Parameter(Mandatory = $true, ParameterSetName = "TitleFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $TitleFilter,

        [Parameter(Mandatory = $true, ParameterSetName = "TypeFilter")]
        [ValidateNotNullOrEmpty()]
        [string]
        $TypeFilter
    )

    if (-not (Test-Path -Path $JsonPath)) {
        Write-Error "Cannot find $JsonPath." -ErrorAction Stop
    }

    if (Test-Path -Path $CdfPath) {
        Remove-Item -Path $CdfPath
    }

    #region header version
    "version {0}" -f $(Get-Date -Format "yyyyMMdd") | Add-Content -Path $CdfPath
    #endregion header version
    
    #region header gif
    if ($CdfPath.EndsWith("Dark.cdf")) {
        "back imp.gif" | Add-Content -Path $CdfPath
    }
    elseif ($CdfPath.EndsWith("Light.cdf")) {
        "back reb.gif" | Add-Content -Path $CdfPath
    }
    else {
        "back placeholder.gif" | Add-Content -Path $CdfPath
    }
    #endregion header gif

    [string]$PreviousSection = ""

    Get-Content -Path $JsonPath |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Where-Object {
        if ($PSCmdlet.ParameterSetName -eq "NoFilter") {
            $true
            # $_.legacy -eq $false
        }
        elseif ($PSCmdlet.ParameterSetName -eq "IdFilter") {
            $_.id -eq $IdFilter
        }
        elseif ($PSCmdlet.ParameterSetName -eq "SetFilter") {
            $_.set -like $SetFilter
        }
        elseif ($PSCmdlet.ParameterSetName -eq "TitleFilter") {
            $_.front.title -like $TitleFilter
        }
        elseif ($PSCmdlet.ParameterSetName -eq "TypeFilter") {
            $_.front.type -like $TypeFilter
        }
    } |
    Select-Object -Property @{Name = "Image"; Expression = { ConvertTo-CdfImage -Context $_ } }, @{Name = "Section"; Expression = { ConvertTo-CdfSection -Context $_ } }, @{Name = "SortTitle"; Expression = { ConvertTo-CdfTitleSort -Context $_ } }, @{Name = "Line"; Expression = { ConvertTo-CdfLine -Context $_ } } |
    Sort-Object -Property "Section", "SortTitle", "Image", "Line" |
    ForEach-Object {
        if ($PreviousSection -ne $_.Section) {
            Write-Output $("`r`n`{0}`r`n" -f $_.Section)
        }
        $PreviousSection = $_.Section
        Write-Output $_.Line
    } |
    Add-Content -Path $CdfPath
}

function ConvertTo-CdfAbility {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.ability
    }
    catch {
        Write-Debug "`tFailed to find or parse Ability."
    }

    Write-Output $output
}

function ConvertTo-CdfArmor {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.armor
    }
    catch {
        Write-Debug "`tFailed to find or parse Armor."
    }

    Write-Output $output
}

function ConvertTo-CdfDeploy {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.deploy
    }
    catch {
        Write-Debug "`tFailed to find or parse Deploy."
    }

    Write-Output $output
}

function ConvertTo-CdfDestiny {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.destiny
    }
    catch {
        Write-Debug "`tFailed to find or parse Destiny."
    }

    Write-Output $output
}

function ConvertTo-CdfExtraText {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.extraText
    }
    catch {
        Write-Debug "`tFailed to find or parse ExtraText."
    }

    Write-Output $output
}

function ConvertTo-CdfForfeit {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.forfeit
    }
    catch {
        Write-Debug "`tFailed to find or parse Forfeit."
    }

    Write-Output $output
}

function ConvertTo-CdfGameText {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.gametext.Replace("Dark:  ", "DARK ($DarkSideIcons): ").Replace("Light:  ", "LIGHT ($LightSideIcons): ")
    }
    catch {
        Write-Debug "`tFailed to find or parse GameText."
    }

    Write-Output $output
}

function ConvertTo-CdfHypderspeed {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.hyperspeed
    }
    catch {
        Write-Debug "`tFailed to find or parse Hypderspeed."
    }

    Write-Output $output
}

function ConvertTo-CdfIcons {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    foreach ($icon in $Context.front.icons) { $output = $output + "$icon, " } ; $output = $output.Trim().Trim(",")

    Write-Output $output
}

# function ConvertTo-CdfIconTag {
#     param(
#         [Parameter(ValueFromPipeline = $true)]
#         [PSCustomObject]
#         $Context
#     )

#     [string]$output = "";

#     $icons = ConvertTo-CdfIcons -Context $Context

#     if ($icons) {
#         $output = "\nIcons: $icons"
#     }

#     Write-Output $output
# }

function ConvertTo-CdfImage {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.imageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")

    Write-Output $output
}

function ConvertTo-CdfLandspeed {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.landspeed
    }
    catch {
        Write-Debug "`tFailed to find or parse Landspeed."
    }

    Write-Output $output
}

function Get-TagString {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context,

        [string]
        $TagName,
        [string]
        $TagValue
    )

    [string]$output = ""

    if ($TagValue -ne "") { $output = "{0}: {1}" -f $TagName, $TagValue }

    $output = $output.Trim()

    Write-Output $output
}

function ConvertTo-CdfLine {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $id = $Context.id
    Write-Verbose "Parsing $id..."

    try {
        $ability = ConvertTo-CdfAbility -Context $Context
        $abilityTag = Get-TagString -Context $Context -TagName "Ability" -TagValue $ability
        $armor = ConvertTo-CdfArmor -Context $Context
        $armorTag = Get-TagString -Context $Context -TagName "Armor" -TagValue $armor
        $deploy = ConvertTo-CdfDeploy -Context $Context
        $deployTag = Get-TagString -Context $Context -TagName "Deploy" -TagValue $deploy
        $destiny = ConvertTo-CdfDestiny -Context $Context
        $extraText = ConvertTo-CdfExtraText -Context $Context
        $forfeit = ConvertTo-CdfForfeit -Context $Context
        $forfeitTag = Get-TagString -Context $Context -TagName "Forfeit" -TagValue $forfeit
        $gametext = ConvertTo-CdfGameText -Context $Context
        $hyperspeed = ConvertTo-CdfHypderspeed -Context $Context
        $hyperspeedTag = Get-TagString -Context $Context -TagName "Hyperspeed" -TagValue $hyperspeed
        $icons = ConvertTo-CdfIcons -Context $Context
        $iconsTag = Get-TagString -Context $Context -TagName "Icons" -TagValue $icons
        $image = ConvertTo-CdfImage -Context $Context
        $landspeed = ConvertTo-CdfLandspeed -Context $Context
        $landspeedTag = Get-TagString -Context $Context -TagName "Landspeed" -TagValue $landspeed
        $lore = ConvertTo-CdfLore -Context $Context
        $loreTag = Get-TagString -Context $Context -TagName "Lore" -TagValue $lore
        $maneuver = ConvertTo-CdfManeuver -Context $Context
        $maneuverTag = Get-TagString -Context $Context -TagName "Maneuver" -TagValue $maneuver
        $power = ConvertTo-CdfPower -Context $Context
        $powerTag = Get-TagString -Context $Context -TagName "Power" -TagValue $power
        $rarity = ConvertTo-CdfRarity -Context $Context
        $set = ConvertTo-CdfSet -Context $Context
        $setTag = Get-TagString -Context $Context -TagName "Set" -TagValue $set
        $side = ConvertTo-CdfSide -Context $Context
        $subType = ConvertTo-CdfSubType -Context $Context
        $textTag = Get-TagString -Context $Context -TagName "Text" -TagValue $gametext
        $title = ConvertTo-CdfTitle -Context $Context
        $type = ConvertTo-CdfType -Context $Context
        $uniqueness = ConvertTo-CdfUniqueness -Context $Context

        $defenseValueTag = "{0}{1}{2}" -f $abilityTag, $armorTag, $maneuverTag
        $speedTag = "{0}{1}" -f $hyperspeedTag, $landspeedTag

        $output =
        switch ($type) {
            "Admiral's Order" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
                # "card `"{0}`" `"{1}{2}{3}{4}{5}`"" -f $part0, $part1, $part2, $part3, $part4, $part5
            }
            "Character" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                if ($extraText -ne "") {
                    $line3 = "{0} {1} {2}\n" -f $powerTag, $defenseValueTag, $extraText
                }
                else {
                    $line3 = "{0} {1}\n" -f $powerTag, $defenseValueTag
                }
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Creature" {
                switch ($id) {
                    2821 <# Womp Rat #> {
                        $defenseValue = "SCURRY: 4"
                    }
                    default {
                        $defenseValue = "{DEFENSE}: {VALUE}"   
                    }
                }
                "card `"$image`" `"$title ($rarity)\n$side $type- $subType [$rarity]\n$setTag $iconsTag\nPower: $power $defenseValue\nDeploy: $deploy Forfeit: $forfeit$iconTag\n\nLore: $lore\n\n$textTag`""
            }
            "Defensive Shield" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\nLore: $lore\n\n$textTag`""
            }
            "Device" {
                "card `"$image`" `"$title ($rarity)\n$side $type [$rarity]\n$setTag $iconsTag\n\nLore: $lore\n\n$textTag`""
            }
            "Effect" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Epic Event" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Game Aid" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rariry]\n$setTag $iconsTag\nText: $text`""
            }
            "Interrupt" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Jedi Test #1" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTagt`""
            }
            "Jedi Test #2" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Jedi Test #3" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Jedi Test #4" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Jedi Test #5" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Jedi Test #6" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\n$setTag $iconsTag\n\n$textTag`""
            }
            "Location" {
                if ($uniqueness -contains "*") {
                    $uniqueness = ""
                }
                "card `"$image`" `"$uniqueness$title ($destiny)\n$side $type - $subType [$rarity]\n$setTag $iconsTag\n\nText:\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Mission" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Objective" {
                "card `"/TWOSIDED$image`" `"$title (0/7)\n$side $type [$rarity]\n$setTag $iconsTag\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Podracer" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Starship" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = "{0} {1} {2}\n" -f $powerTag, $defenseValueTag, $speedTag
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Vehicle" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = "{0} {1} {2}\n" -f $powerTag, $defenseValueTag, $speedTag
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Weapon" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $textTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            default {
                Write-Warning "Type = $type, Title = $title, Error = Card type not supported."
            }
        }
    }
    catch {
        Write-Error "`tFailed to parse Line."
        Write-Error $_
    }
    Write-Debug $output
    Write-Output $output
}

function ConvertTo-CdfLore {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.lore
    }
    catch {
        Write-Debug "`tFailed to find or parse Lore."
    }

    Write-Output $output
}

function ConvertTo-CdfManeuver {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.maneuver
    }
    catch {
        Write-Debug "`tFailed to find or parse Maneuver."
    }

    Write-Output $output
}

function ConvertTo-CdfPower {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.power
    }
    catch {
        Write-Debug "`tFailed to find or parse Power."
    }

    Write-Output $output
}

function ConvertTo-CdfRarity {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.rarity
    }
    catch {
        Write-Debug "`tFailed to find or parse Rarity."
    }

    Write-Output $output
}

function ConvertTo-CdfSection {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        if ($Context.front.subType) {
            $output = $("[{0} - {1}]" -f $Context.front.type, $Context.front.subType.Split(":")[0]).Replace(" - ]", "]")
        }
        else {
            $output = "[{0}]" -f $Context.front.type
        }
    }
    catch {
        Write-Debug "`tFailed to find or parse Section."
    }

    Write-Output $output
}

function ConvertTo-CdfSet {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.set
    }
    catch {
        Write-Debug "`tFailed to find or parse Set."
    }

    Write-Output $output
}

function ConvertTo-CdfSide {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.side
    }
    catch {
        Write-Debug "`tFailed to find or parse Side."
    }

    Write-Output $output
}

function ConvertTo-CdfSubType {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.subType
    }
    catch {
        Write-Debug "`tFailed to find or parse SubType."
    }

    Write-Output $output
}

function ConvertTo-CdfTitle {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.title.Replace("<>", "")
    }
    catch {
        Write-Debug "`tFailed to find or parse Title."
    }

    Write-Output $output
}


function ConvertTo-CdfTitleSort {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.title.Replace("<>", "").Replace("•", "")
    }
    catch {
        Write-Debug "`tFailed to find or parse TitleSort."
    }

    Write-Output $output
}

function ConvertTo-CdfType {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.type
    }
    catch {
        Write-Debug "`tFailed to find or parse Type."
    }

    Write-Output $output
}

function ConvertTo-CdfUniqueness {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.uniqueness
    }
    catch {
        Write-Debug "`tFailed to find or parse Type."
    }

    Write-Output $output
}

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
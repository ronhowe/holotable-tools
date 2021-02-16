#region Convert Functions

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
        Write-Debug "`tFailed to find or parse ability."
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
        Write-Debug "`tFailed to find or parse armor."
    }

    Write-Output $output
}

function ConvertTo-CdfDarkSideIcons {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.darkSideIcons
    }
    catch {
        Write-Debug "`tFailed to find or parse darkSideIcons."
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
        Write-Debug "`tFailed to find or parse deploy."
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

        if ($Context.back.destiny) {
            $output = "{0}/{1}" -f $Context.front.destiny, $Context.back.destiny
        }
        else {
            $output = $Context.front.destiny
        }
    }
    catch {
        Write-Debug "`tFailed to find or parse destiny."
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
        Write-Debug "`tFailed to find or parse extraText."
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
        switch ($Context.id) {
            1073 {
                # Greedo
                $output = "1/2"
            }
            default {
                $output = $Context.front.forfeit
            }
        }
    }
    catch {
        Write-Debug "`tFailed to find or parse forfeit."
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
        $output = $Context.front.gametext

        if ($Context.conceptBy -and $Context.conceptBy -ne "") {
            $output = "{0}\n\n{1}" -f $output, $Context.conceptBy
        }

        @("LOST:", "USED:", "STARTING:", "Requirements:", "Wild cards (0-7):", "Wild cards (1-6):", "Wild cards (2-7):", "Clone cards:", "Stakes:") |
        ForEach-Object {
            if ($output.Contains($_)) {
                $output = $output.Replace($_, "\n$_") 
            }
        }

        # Commence Primary Ignition
        if ($Context.id -eq 508) {
            @(" Name the System:", " You May Fire When Ready:", " Stand By:", " X =", " Y =", " Z =") |
            ForEach-Object {
                if ($output.Contains($_)) {
                    $output = $output.Replace($_, "\n$($_.Trim())") 
                }
            }
        }

        # Target The Main Generator
        if ($Context.id -eq 2422) {
            @(" Prepare To Target The Main Generator:", " Maximum Firepower!:", " X =", " Y =") |
            ForEach-Object {
                if ($output.Contains($_)) {
                    $output = $output.Replace($_, "\n$($_.Trim())") 
                }
            }
        }
    }
    catch {
        Write-Debug "`tFailed to find or parse gametext."
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
        Write-Debug "`tFailed to find or parse hyperspeed."
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

function ConvertTo-CdfImage {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    if ($Context.back.imageUrl) {
        $front = $Context.front.imageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")
        $back = $(Split-Path -Path $Context.back.imageUrl -Leaf).Replace(".gif?raw=true", "")
        $output = "/TWOSIDED{0}/{1}" -f $front, $back
    }
    else {
        $output = $Context.front.imageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")
    }

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
        Write-Debug "`tFailed to find or parse landspeed."
    }

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
    Write-Verbose "Parsing id = $id..."

    try {
        $ability = ConvertTo-CdfAbility -Context $Context
        $abilityTag = Format-CdfTagPrefix -Context $Context -TagName "Ability" -TagValue $ability
        $armor = ConvertTo-CdfArmor -Context $Context
        $armorTag = Format-CdfTagPrefix -Context $Context -TagName "Armor" -TagValue $armor
        $darkSideIcons = ConvertTo-CdfDarkSideIcons -Context $Context
        $deploy = ConvertTo-CdfDeploy -Context $Context
        $deployTag = Format-CdfTagPrefix -Context $Context -TagName "Deploy" -TagValue $deploy
        $destiny = ConvertTo-CdfDestiny -Context $Context
        $extraText = ConvertTo-CdfExtraText -Context $Context
        $forfeit = ConvertTo-CdfForfeit -Context $Context
        $forfeitTag = Format-CdfTagPrefix -Context $Context -TagName "Forfeit" -TagValue $forfeit
        $gametext = ConvertTo-CdfGameText -Context $Context
        $gametextTag = Format-CdfTagPrefix -Context $Context -TagName "Text" -TagValue $gametext
        $hyperspeed = ConvertTo-CdfHypderspeed -Context $Context
        $hyperspeedTag = Format-CdfTagPrefix -Context $Context -TagName "Hyperspeed" -TagValue $hyperspeed
        $icons = ConvertTo-CdfIcons -Context $Context
        $iconsTag = Format-CdfTagPrefix -Context $Context -TagName "Icons" -TagValue $icons
        $image = ConvertTo-CdfImage -Context $Context
        $landspeed = ConvertTo-CdfLandspeed -Context $Context
        $landspeedTag = Format-CdfTagPrefix -Context $Context -TagName "Landspeed" -TagValue $landspeed
        $lightSideIcons = ConvertTo-CdfLightSideIcons -Context $Context
        $lore = ConvertTo-CdfLore -Context $Context
        $loreTag = Format-CdfTagPrefix -Context $Context -TagName "Lore" -TagValue $lore
        $maneuver = ConvertTo-CdfManeuver -Context $Context
        $maneuverTag = Format-CdfTagPrefix -Context $Context -TagName "Maneuver" -TagValue $maneuver
        $parsec = ConvertTo-CdfParsec -Context $Context
        $parsecTag = Format-CdfTagPrefix -Context $Context -TagName "Parsec" -TagValue $parsec
        $politics = ConvertTo-CdfPolitics -Context $Context
        $politicsTag = Format-CdfTagPrefix -Context $Context -TagName "Politics" -TagValue $politics
        $power = ConvertTo-CdfPower -Context $Context
        $powerTag = Format-CdfTagPrefix -Context $Context -TagName "Power" -TagValue $power
        $rarity = ConvertTo-CdfRarity -Context $Context
        $set = ConvertTo-CdfSet -Context $Context
        $setTag = Format-CdfTagPrefix -Context $Context -TagName "Set" -TagValue $set
        $side = ConvertTo-CdfSide -Context $Context
        $subType = ConvertTo-CdfSubType -Context $Context
        $title = ConvertTo-CdfTitle -Context $Context
        $type = ConvertTo-CdfType -Context $Context
        # $uniqueness = ConvertTo-CdfUniqueness -Context $Context

        $output =
        switch ($type) {
            "Admiral's Order" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Character" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = @($powerTag, $abilityTag, $armorTag, $maneuverTag, $politicsTag, $extraText) | Format-CdfTagGroup
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Creature" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = @($powerTag, $extraText) | Format-CdfTagGroup
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Defensive Shield" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Device" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Effect" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                if ($subType -eq "") {
                    $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                }
                else {
                    $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                }
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = if ($loreTag -ne "") { "{0}\n\n" -f $loreTag } else { "" }
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Epic Event" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Game Aid" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Interrupt" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = if ($loreTag -ne "") { "{0}\n\n" -f $loreTag } else { "" }
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Jedi Test #1" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #2" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #3" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #4" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #5" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #6" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Location" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = if ($parsecTag -ne "") { "{0}\n" -f $parsecTag } else { "" }
                $line5 = "{0}" -f $gametextTag.Replace("Dark:  ", "DARK ($darkSideIcons): ").Replace("Light:  ", "LIGHT ($lightSideIcons): ").Replace("Dark:", "DARK ($darkSideIcons): ").Replace("Light:", "LIGHT ($lightSideIcons): ").Replace("Text: DARK (", "Text:\nDARK (").Replace("Text: LIGHT (", "Text:\nLIGHT (").Replace(".  DARK (", ".\n\nDARK (").Replace(".  LIGHT (", ".\n\nLIGHT (").Replace(".'  DARK (", ".'\n\nDARK (").Replace(".'  LIGHT (", ".'\n\nLIGHT (")

                "card `"$image`" `"{0}{1}{2}{3}{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Mission" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Objective" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $frontTitle = $title.Split('/').Trim()[0]
                $backTitle = $title.Split('/').Trim()[1].Replace(' (V)', '')
                $line4 = "{0}" -f $gametext.Replace("$frontTitle`:", "$frontTitle`:\n\n").Replace($backTitle, "\n\n$backTitle").Replace('. {', '.{').Replace('{', '\n{')

                "card `"$image`" `"{0}{1}{2}{3}\n{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Podracer" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}\n" -f $loreTag
                $line5 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}\n{4}\n{5}`"" -f $line0, $line1, $line2, $line3, $line4, $line5
            }
            "Starship" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = @($powerTag, $armorTag, $maneuverTag, $hyperspeedTag, $extraText) | Format-CdfTagGroup
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Vehicle" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = @($powerTag, $armorTag, $maneuverTag, $landspeedTag, $extraText) | Format-CdfTagGroup
                $line4 = "{0} {1}\n" -f $deployTag, $forfeitTag
                $line5 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line6 = "{0}\n" -f $loreTag
                $line7 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}{4}{5}\n{6}\n{7}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6, $line7
            }
            "Weapon" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} - {2} [{3}]\n" -f $side, $type, $subType, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = if ($deployTag -ne "" -and $forfeitTag -ne "") { "{0} {1}\n" -f $deployTag, $forfeitTag } else { "" }
                $line5 = "{0}\n" -f $loreTag
                $line6 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}{4}\n{5}\n{6}`"" -f $line0, $line1, $line2, $line3, $line4, $line5, $line6
            }
            default {
                Write-Warning "Type = $type, Title = $title, Error = Card type not supported."
            }
        }
    }
    catch {
        Write-Warning "`tFailed to parse context."
        Write-Debug $Context
        Write-Debug $_
    }

    # Add various shims and hacks.
    $output = $output.Replace('Text: \n', 'Text:\n').Replace('.)  \n', '.)\n\n').Replace('.  \n', '.\n\n').Replace('. \n', '.\n').Replace('! \n', '!\n').Replace('.) \n', '.)\n').Replace('•', '�')

    Write-Debug $output
    Write-Output $output
}

function ConvertTo-CdfLightSideIcons {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.lightSideIcons
    }
    catch {
        Write-Debug "`tFailed to find or parse lightSideIcons."
    }

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
        Write-Debug "`tFailed to find or parse lore."
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
        Write-Debug "`tFailed to find or parse maneuver."
    }

    Write-Output $output
}

function ConvertTo-CdfParsec {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.parsec

        if ((-not $output) -and ($Context.front.subType -eq "System")) {
            $output = "X"
        }
    }
    catch {
        Write-Debug "`tFailed to find or parse parsec."
    }

    Write-Output $output
}

function ConvertTo-CdfPolitics {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.politics
    }
    catch {
        Write-Debug "`tFailed to find or parse politics."
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
        Write-Debug "`tFailed to find or parse power."
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
        Write-Debug "`tFailed to find or parse rarity."
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
        Write-Debug "`tFailed to find or parse section."
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
        $output = $Context.set.Replace("Virtual Set", "Set").Replace("Demo Deck", "Virtual Premium Set")
    }
    catch {
        Write-Debug "`tFailed to find or parse set."
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
        Write-Debug "`tFailed to find or parse side."
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
        Write-Debug "`tFailed to find or parse subType."
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
        $output = $Context.front.title
    }
    catch {
        Write-Debug "`tFailed to find or parse title."
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
        Write-Debug "`tFailed to find or parse titleSort."
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
        Write-Debug "`tFailed to find or parse type."
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
        Write-Debug "`tFailed to find or parse uniqueness."
    }

    Write-Output $output
}

#endregion Convert Functions

#region Export Functions

function Export-Cdf {
    <#
    .SYNOPSIS
    This script attempts to parse a JSON file in the swccg-card-json repo to the approximate format of a Holotable CDF file.

    .DESCRIPTION
    This script attempts to parse a JSON file in the swccg-card-json repo to the approximate format of a Holotable CDF file.

    .PARAMETER JsonPath
    The path to the input JSON file.

    .PARAMETER CdfPath
    The path to the output CDF file.

    .PARAMETER Id
    The id to parse.  Valid values can be found in the input JSFON file "id" properties.

    .PARAMETER Set
    The set to parse.  Valid values can be found in the input JSFON file "set" properties.

    .PARAMETER Title
    The title to parse.  Valid values can be found in the input JSFON file "title" properties.

    .PARAMETER Type
    The type to parse.  Valid values can be found in the input JSFON file "type" properties.

    .EXAMPLE
    PS> ./Export-Cdf.ps1 -JsonPath "./Light.json" -CdfPath "./Light.cdf" -Id 5300

    .EXAMPLE
    PS> ./Export-Cdf.ps1 -JsonPath "./Dark.json" -CdfPath "./Dark.cdf" -Set "Virtual Set 13"

    .EXAMPLE
    PS> ./Export-Cdf -JsonPath "./Light.json" -CdfPath "./Light.cdf" -TitleFilter "*Rebel Leadership*"

    .EXAMPLE
    PS> ./Export-Cdf -JsonPath "./Light.json" -CdfPath "./Light.cdf" -TypeFilter "Admiral*"
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

    "version {0}" -f $(Get-Date -Format "yyyyMMdd") | Add-Content -Path $CdfPath -Encoding utf8
    
    if ($CdfPath.EndsWith("Dark.cdf")) {
        "back imp.gif" | Add-Content -Path $CdfPath -Encoding utf8
    }
    elseif ($CdfPath.EndsWith("Light.cdf")) {
        "back reb.gif" | Add-Content -Path $CdfPath -Encoding utf8
    }

    [string]$PreviousSection = ""

    Get-Content -Path $JsonPath |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Where-Object {
        if ($PSCmdlet.ParameterSetName -eq "IdFilter") {
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
        else {
            $true
        }
    } |
    Sort-Object -Property "id" |
    Select-Object -Property @{Name = "Image"; Expression = { ConvertTo-CdfImage -Context $_ } }, @{Name = "Section"; Expression = { ConvertTo-CdfSection -Context $_ } }, @{Name = "SortTitle"; Expression = { ConvertTo-CdfTitleSort -Context $_ } }, @{Name = "Line"; Expression = { ConvertTo-CdfLine -Context $_ } } |
    Sort-Object -Property "Section", "SortTitle", "Image", "Line" |
    ForEach-Object {
        if ($PreviousSection -ne $_.Section) {
            Write-Output $("`r`n`{0}`r`n" -f $_.Section)
        }
        $PreviousSection = $_.Section
        Write-Output $_.Line
    } |
    Add-Content -Path $CdfPath -Encoding utf8
}

function Export-BasicCdf () {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $CdfInputPath,

        [Parameter()]
        [string]
        $CdfOutputPath,

        [Parameter()]
        [switch]
        $ExcludeLegacy = $false
    )

    if (Test-Path -Path $CdfOutputPath) {
        Remove-Item $CdfOutputPath -Force
    }

    if (Test-Path -Path $CdfInputPath) {
        Get-Content -Path $CdfInputPath |
        Where-Object {
            ($_.StartsWith("card `"/starwars")) -or
            ($_.StartsWith("card `"/TWOSIDED")) -or
            $($_.StartsWith("card `"/legacy") -and -not $ExcludeLegacy)
        } |
        Sort-Object |
        Add-Content -Path $CdfOutputPath -Encoding utf8
    }
    else {
        Write-Host "Could not find $CdfInputPath"
    }
}

#endregion Export Functions

#region Format Functions

function Format-CdfTagGroup {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $chunks
    )
    begin {
        $output = ""
    }
    process {
        $chunks |
        ForEach-Object {
            if ($_ -ne "") {
                $output = $output + $("{0} " -f $_)
            }
        }
    }
    end {
        $output = $output.Trim() + "\n"
        Write-Output $output
    }
}

function Format-CdfTagPrefix {
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

#endregion Format Functions

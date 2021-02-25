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
        Write-Warning "Failed to parse ability."
    }

    Write-ParseLog -Key "ability" -Value $output
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
        Write-Warning "Failed to parse armor."
    }

    Write-ParseLog -Key "armor" -Value $output
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
        switch ($Context.id) {
            319 {
                # Brainiac
                $output = "Y"
            }
            default {
                $output = $Context.front.deploy
            }
        }
    }
    catch {
        Write-Warning "Failed to parse deploy."
    }

    Write-ParseLog -Key "deploy" -Value $output
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
            switch ($Context.id) {
                136 {
                    # Artoo
                    $output = "1 or 6"
                }
                141 {
                    # Artoo-Detoo In Red 5
                    $output = "0 or 7"
                }
                5373 {
                    # BB-8 In Black Squadron 1
                    $output = "pi"
                }
                319 {
                    # Brainiac
                    $output = "pi"
                }
                6849 {
                    # Puck
                    $output = "7 or 1"
                }
                1992 {
                    # R2-D2 (Artoo-Detoo)
                    $output = "2 or 5"
                }
                1993 {
                    # R2-D2 (Artoo-Detoo) (V)
                    $output = "2 or 5"
                }
                default {
                    $output = $Context.front.destiny
                }
            }
        }
    }
    catch {
        Write-Warning "Failed to parse destiny."
    }

    Write-ParseLog -Key "destiny" -Value $output
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
        Write-Warning "Failed to parse extraText."
    }

    Write-ParseLog -Key "extraText" -Value $output
    Write-Output $output
}

function ConvertTo-CdfForceIconsDark {
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
        Write-Warning "Failed to parse darkSideIcons."
    }

    Write-ParseLog -Key "darkSideIcons" -Value $output
    Write-Output $output
}

function ConvertTo-CdfForceIconsLight {
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
        Write-Warning "Failed to parse lightSideIcons."
    }

    Write-ParseLog -Key "lightSideIcons" -Value $output
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
            319 {
                # Brainiac
                $output = "X"
            }
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
        Write-Warning "Failed to parse forfeit."
    }

    Write-ParseLog -Key "forfeit" -Value $output
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

        @("LOST:", "USED:", "STARTING:", "Requirements:", "Wild cards (0-7):", "Wild cards (1-6):", "Wild cards (2-7):", "Clone cards:", "Stakes:", "Mentor:") |
        ForEach-Object {
            # Shim for Reveal Ourselves To The Jedi
            if (($output.Contains($_)) -and ($Context.id -ne 2108)) {
                $output = $output.Replace($_, "\n$_") 
            }
        }

        # Attack Run
        if ($Context.id -eq 169) {
            @(" Enter Trench:", " Provide Cover:", " It's Away!:", " Pull Up!:", " X =", " Y =", " Z =", " *Your Proton") |
            ForEach-Object {
                if ($output.Contains($_)) {
                    $output = $output.Replace($_, "\n$($_.Trim())") 
                }
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

        # Commence Primary Ignition (V)
        if ($Context.id -eq 6187) {
            @(" Prepare Single Reactor Ignition:", " Fire!:", " It's Beautiful:", " X =") |
            ForEach-Object {
                if ($output.Contains($_)) {
                    $output = $output.Replace($_, "\n$($_.Trim())") 
                }
            }
        }

        # Hyperoute Navigation Chart
        if ($Context.id -eq 6365) {
            @("[0]", " [1]", " [2]", " [3]", " [4]", " [5]", " [6]", " [7]", " [8]", " [9]", " * Known Rebel Base") |
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
        Write-Warning "Failed to parse gametext."
    }

    Write-ParseLog -Key "gametext" -Value $output
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
        Write-Warning "Failed to parse hyperspeed."
    }

    Write-ParseLog -Key "hyperspeed" -Value $output
    Write-Output $output
}

function ConvertTo-CdfIcons {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    foreach ($icon in $Context.front.icons) {
        if ($icon -ne "Defensive Shield") {
            $output = $output + "$icon, "
        }
    }
    
    $output = $output.Trim().Trim(",")

    Write-ParseLog -Key "icons" -Value $output
    Write-Output $output
}

function ConvertTo-CdfImage {
    [CmdletBinding()]
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

    Write-ParseLog -Key "image" -Value $output
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
        Write-Warning "Failed to parse landspeed."
    }

    Write-ParseLog -Key "landspeed" -Value $output
    Write-Output $output
}

function ConvertTo-CdfLine {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    Write-ParseLog -Key "id" -Value $Context.id

    try {
        $ability = ConvertTo-CdfAbility -Context $Context
        $abilityTag = Format-CdfTagPrefix -Context $Context -TagName "Ability" -TagValue $ability
        $armor = ConvertTo-CdfArmor -Context $Context
        $armorTag = Format-CdfTagPrefix -Context $Context -TagName "Armor" -TagValue $armor
        $darkSideIcons = ConvertTo-CdfForceIconsDark -Context $Context
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
        $lightSideIcons = ConvertTo-CdfForceIconsLight -Context $Context
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
                $line7 = if ($gametext -ne "") { "{0}" -f $gametextTag } else { "Text: " }

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
                $line4 = if ($lore -ne "") { "{0}\n" -f $loreTag } else { "Lore:" }
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
                $line3 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}{3}`"" -f $line0, $line1, $line2, $line3
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

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #2" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #3" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #4" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #5" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
            }
            "Jedi Test #6" {
                $line0 = "{0} ({1})\n" -f $title, $destiny
                $line1 = "{0} {1} [{2}]\n" -f $side, $type, $rarity
                $line2 = "{0}\n" -f $setTag
                $line3 = if ($iconsTag -ne "") { "{0}\n" -f $iconsTag } else { "" }
                $line4 = "{0}" -f $gametextTag

                "card `"$image`" `"{0}{1}{2}\n{3}{4}`"" -f $line0, $line1, $line2, $line3, $line4
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

        # Add various shims and hacks.
        $output = $output.Replace('Text: \n', 'Text:\n').Replace('.)  \n', '.)\n\n').Replace('.  \n', '.\n\n').Replace('. \n', '.\n').Replace('! \n', '!\n').Replace('.) \n', '.)\n').Replace('•', '�')

        # Luke Skywalker, The Emperor's Prize
        if ($Context.id -eq 6501) {
            Write-Warning "Game text of `"Luke Skywalker, The Emperor's Prize`" is hard-coded."
            $output = "card `"/TWOSIDED/starwars/Virtual5-Dark/t_lukeskywalkertheemperorsprizefront/lukeskywalkertheemperorsprizeback`" `"�Luke Skywalker, The Emperor's Prize/Luke Skywalker, The Emperor's Prize (0/7)\nDark Character - Rebel [R]\nSet: Set 5\nPower: 0 Ability: 0 Carbon-Frozen\nDeploy: 0 Forfeit: 0\n\nLuke Skywalker, The Emperor's Prize:\n\nText: This is a Dark Side card and does not count toward your deck limit. Reveal to opponent when deploying your Starting Effect. Deploys to Death Star II: Throne Room only at start of game as a frozen captive if Bring Him Before Me on table and Your Destiny is suspended; otherwise place out of play. For remainder of game, may not be placed in Reserve Deck. This is a persona of Luke only while on table. While this side up, Bring Him Before Me may not flip. May not be escorted. Flip this card if Vader present and not escorting a captive. Place out of play if released or about to leave table.\n\nLuke Skywalker, The Emperor's Prize:\n\nPower: 6 Ability: 6 Jedi Knight\nImmediately 'thaw' Luke (Luke is a non-frozen captive escorted by Vader). While this side up, subtracts 3 from attempts to cross Luke over (even while a captive). Place out of play if released or about to leave table.`""
        }
        
        # The Falcon, Junkyard Garbage
        if ($Context.id -eq 5959) {
            Write-Warning "Game text of `"The Falcon, Junkyard Garbage`" is hard-coded."
            $output = "card `"/TWOSIDED/starwars/Virtual4-Light/t_thefalconjunkyardgarbagefront/thefalconjunkyardgarbageback`" `"�The Falcon, Junkyard Garbage/�The Falcon, Junkyard Garbage (0/7)\nLight Starship - Starfighter: Heavily-Modified Light Freighter [C]\nSet: Set 4\nPower: 3 Maneuver: 4 Hyperspeed: 6\nDeploy: 0 Forfeit: 7\nIcons: Nav Computer, Resistance, Scomp Link, Episode VII\n\n�The Falcon, Junkyard Garbage\n\nLore: The Millennium Falcon's well-known reputation is favorable not only for its captain and first mate, but for the Alliance as well.\n\nText: May not be placed in Reserve Deck. If Falcon about to leave table, place it out of play. May add 2 pilots and 2 passengers. Has ship-docking capability. While [Episode VII] Han or Rey piloting, maneuver +2 and immune to attrition < 4 (< 6 if both). Once during your move phase, if at a site, may flip this card (even if unpiloted).\n\n�The Falcon, Junkyard Garbage\nLight Combat Vehicle - Heavily-Modified Light Freighter\nPower: 3 Maneuver: 5 Landspeed: 2\nDeploy: 0 Forfeit: 7\nIcons: Resistance, Scomp Link, Episode VII\n\nLore: Han's 'special modifications' for Millennium Falcon included security mechanisms, deflector shields, hull plating, faster hyperdrive and enhanced weapons. Enclosed.\n\nText: May not be placed in Reserve Deck. If Falcon about to leave table, place it out of play. May add 2 pilots and 2 passengers. Immune to Trample and Unsalvageable, even if unpiloted. While Finn or Rey aboard, immune to attrition < 4 (< 6 if both). Once during your move phase, if piloted, may flip this card.`""
        }
    }
    catch {
        Write-Warning "Failed to parse context."
    }

    Write-ParseLog -Key "line" -Value $output
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
        Write-Warning "Failed to parse lore."
    }

    Write-ParseLog -Key "lore" -Value $output
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
        Write-Warning "Failed to parse maneuver."
    }

    Write-ParseLog -Key "maneuver" -Value $output
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
        Write-Warning "Failed to parse parsec."
    }

    Write-ParseLog -Key "parsec" -Value $output
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
        Write-Warning "Failed to parse politics."
    }

    Write-ParseLog -Key "politics" -Value $output
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
        Write-Warning "Failed to parse power."
    }

    Write-ParseLog -Key "power" -Value $output
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
        Write-Warning "Failed to parse rarity."
    }

    Write-ParseLog -Key "rarity" -Value $output
    Write-Output $output
}

function ConvertTo-CdfSection {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        if (($Context.front.subType) -and ($Context.front.type -ne "Creature")) {
            $output = $("[{0} - {1}]" -f $Context.front.type, $Context.front.subType.Split(":")[0]).Replace(" - ]", "]")
        }
        else {
            $output = "[{0}]" -f $Context.front.type
        }
    }
    catch {
        Write-Warning "Failed to parse section."
    }

    Write-ParseLog -Key "section" -Value $output
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
        Write-Warning "Failed to parse set."
    }

    Write-ParseLog -Key "set" -Value $output
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
        Write-Warning "Failed to parse side."
    }

    Write-ParseLog -Key "side" -Value $output
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
        Write-Warning "Failed to parse subType."
    }

    Write-ParseLog -Key "subType" -Value $output
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
        Write-Warning "Failed to parse title."
    }

    Write-ParseLog -Key "title" -Value $output
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
        Write-Warning "Failed to parse titleSort."
    }

    Write-ParseLog -Key "titleSort" -Value $output
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
        Write-Warning "Failed to parse type."
    }

    Write-ParseLog -Key "type" -Value $output
    Write-Output $output
}

#endregion Convert Functions

#region Export Functions

function Export-Cdf {
    <#
    .SYNOPSIS
    This cmdlet exports a Holotable CDF file from a swccg-card-json JSON file.

    .DESCRIPTION
    This cmdlet attempts to parse a swccg-card-json JSON file and creates a Holotable compatible CDF file.

    .PARAMETER JsonPath
    The path to the input JSON file.

    .PARAMETER CdfPath
    The path to the output CDF file.

    .PARAMETER Id
    The id to parse.  Valid values can be found in the input JSON file "id" properties.

    .PARAMETER Set
    The set to parse.  Valid values can be found in the input JSON file "set" properties.  Supports * wildcards.

    .PARAMETER Title
    The title to parse.  Valid values can be found in the input JSON file "title" properties.  Supports * wildcards.

    .PARAMETER Type
    The type to parse.  Valid values can be found in the input JSON file "type" properties.  Supports * wildcards.

    .PARAMETER ExcludeLegacy
    Whether or not to exclude legacy cards.  Default = $false.

    .EXAMPLE
    PS> ./Export-Cdf.ps1 -JsonPath ./Light.json -CdfPath ./Light.cdf -Id 5300

    .EXAMPLE
    PS> ./Export-Cdf.ps1 -JsonPath ./Dark.json -CdfPath ./Dark.cdf -Set "Virtual Set 13"

    .EXAMPLE
    PS> ./Export-Cdf -JsonPath ./Light.json -CdfPath ./Light.cdf -TitleFilter "*Rebel Leadership*"

    .EXAMPLE
    PS> ./Export-Cdf -JsonPath ./Light.json -CdfPath ./Light.cdf -TypeFilter "Admiral*"

    .EXAMPLE
    PS> ./Export-Cdf -JsonPath ./Light.json -CdfPath ./Light.cdf -ExcludeLegacy
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
        $TypeFilter,

        [Parameter()]
        [switch]
        $ExcludeLegacy = $false
    )

    if (-not (Test-Path -Path $JsonPath)) {
        Write-Error "Cannot find $JsonPath."
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
        $(
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
                $true -and -not ($_.legacy -and $ExcludeLegacy)
            }) -and -not ($_.legacy -and $ExcludeLegacy)
    } |
    Select-Object -Property @{Name = "Line"; Expression = { ConvertTo-CdfLine -Context $_ } }, @{Name = "Image"; Expression = { ConvertTo-CdfImage -Context $_ -Debug:$false } }, @{Name = "Section"; Expression = { ConvertTo-CdfSection -Context $_  -Debug:$false } }, @{Name = "SortTitle"; Expression = { ConvertTo-CdfTitleSort -Context $_  -Debug:$false } }  |
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

    if (-not (Test-Path -Path $CdfInputPath)) {
        Write-Error "Cannot find $CdfInputPath."
    }

    if (Test-Path -Path $CdfOutputPath) {
        Remove-Item $CdfOutputPath -Force
    }

    Get-Content -Path $CdfInputPath |
    Where-Object {
        if ($_.StartsWith("card")) {
            if ($_.Contains('/legacy') -and $ExcludeLegacy) {
                return $false
            }
            else {
                return $true
            }
        }
        else {
            return $false
        }
    } |
    Sort-Object |
    Add-Content -Path $CdfOutputPath -Encoding utf8
}

#endregion Export Functions

#region Format Functions

function Format-CdfTagGroup {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline = $true)]
        [string[]]
        $Tags
    )
    begin {
        $output = ""
    }
    process {
        $Tags |
        ForEach-Object {
            if ($_ -ne "") {
                $output = $output + $("{0} " -f $_)
            }
        }
    }
    end {
        $output = $output.Trim() + "\n"

        Write-ParseLog -Key "tagGroup" -Value $output
        Write-Output $output
    }
}

function Format-CdfTagPrefix {
    [CmdletBinding()]
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

    if ($TagValue -ne "") {
        $output = "{0}: {1}" -f $TagName, $TagValue
    }

    $output = $output.Trim()

    Write-ParseLog -Key "tagPrefix" -Value $output
    Write-Output $output
}

#endregion Format Functions

#region Log Functions

function Write-ParseLog {
    [CmdletBinding()]
    param (
        [string]$Key,
        [string]$Value
    )

    $output = "{0} = {1}" -f $Key, $Value

    Write-Debug $output
}

#endregion Log Functions

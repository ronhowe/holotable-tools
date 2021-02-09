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

    $subTypeGroup = ""

    $json = Get-Content -Path $JsonPath | ConvertFrom-Json

    $json.cards |
    Where-Object {
        (-not $_.legacy) -and {
            if ($PSCmdlet.ParameterSetName -eq "NoFilter") {
                $true
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
        }
    } |
    ForEach-Object {
        Write-Verbose "Parsing id = $($_.id), title = $($_.front.title)..."

        Write-Debug "Parsing id..."
        Write-Debug "`tProperty = $($_.id)"
        $id = $_.id
        Write-Debug "`tValue = $id"

        Write-Debug "Parsing ability..."
        Write-Debug "`tProperty = $($_.front.ability)"
        $ability = $_.front.ability
        Write-Debug "`tValue = $ability"

        Write-Debug "Parsing armor..."
        Write-Debug "`tProperty = $($_.front.armor)"
        $armor = $_.front.armor
        Write-Debug "`tValue = $armor"

        Write-Debug "Parsing deploy..."
        Write-Debug "`tProperty = $($_.front.deploy)"
        $deploy = $_.front.deploy
        Write-Debug "`tValue = $deploy"

        Write-Debug "Parsing destiny..."
        Write-Debug "`tProperty = $($_.front.destiny)"
        $destiny = $_.front.destiny
        Write-Debug "`tValue = $destiny"

        Write-Debug "Parsing forfeit..."
        Write-Debug "`tProperty = $($_.front.forfeit)"
        $forfeit = $_.front.forfeit
        Write-Debug "`tValue = $forfeit"

        Write-Debug "Parsing gametext..."
        Write-Debug "`tProperty = $($_.front.gametext)"
        $gametext = ""
        if ($_.front.gametext) {
            $gametext = $_.front.gametext.Replace("Dark:  ", "DARK ($($_.front.darkSideIcons)): ").Replace("Light:  ", "LIGHT ($($_.front.lightSideIcons)): ").Replace("’", "'").Replace("•", "�")
        }
        Write-Debug "`tValue = $gametext"

        Write-Debug "Parsing hyperspeed..."
        Write-Debug "`tProperty = $($_.front.hyperspeed)"
        $hyperspeed = $_.front.hyperspeed
        Write-Debug "`tValue = $hyperspeed"

        Write-Debug "Parsing icons..."
        Write-Debug "`tProperty = $($_.front.icons)"
        $icons = "" ; foreach ($icon in $_.front.icons) { $icons = $icons + "$icon, " } ; $icons = $icons.Trim().Trim(",")
        if ($icons -ne "") {
            $icons = "\nIcons: $icons"
        }
        Write-Debug "`tValue = $icons"

        Write-Debug "Parsing image..."
        Write-Debug "`tProperty = $($_.front.imageUrl)"
        $image = $_.front.imageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")
        Write-Debug "`tValue = $image"

        Write-Debug "Parsing landspeed..."
        Write-Debug "`tProperty = $($_.front.landspeed)"
        $landspeed = $_.front.landspeed
        Write-Debug "`tValue = $landspeed"

        Write-Debug "Parsing lore..."
        Write-Debug "`tProperty = $($_.front.lore)"
        $lore = $_.front.lore
        Write-Debug "`tValue = $lore"

        Write-Debug "Parsing power..."
        Write-Debug "`tProperty = $($_.front.power)"
        $power = $_.front.power
        Write-Debug "`tValue = $power"

        Write-Debug "Parsing rarity..."
        Write-Debug "`tProperty = $($_.rarity)"
        $rarity = $_.rarity
        Write-Debug "`tValue = $rarity"

        Write-Debug "Parsing set..."
        Write-Debug "`tProperty = $($_.set)"
        $set = $_.set
        Write-Debug "`tValue = $set"

        Write-Debug "Parsing side..."
        Write-Debug "`tProperty = $($_.side)"
        $side = $_.side
        Write-Debug "`tValue = $side"

        Write-Debug "Parsing subType..."
        Write-Debug "`tProperty = $($_.front.subType)"
        $subType = $_.front.subType
        Write-Debug "`tValue = $subType"

        Write-Debug "Parsing title..."
        Write-Debug "`tProperty = $($_.front.title)"
        $title = $_.front.title.Replace("<>", "").Replace("•", "�")
        Write-Debug "`tValue = $title"

        Write-Debug "Parsing titleSort..."
        Write-Debug "`tProperty = $($_.front.title)"
        $titleSort = $_.front.title.Replace("<>", "").Replace("•", "")
        Write-Debug "`tValue = $titleSort"

        Write-Debug "Parsing type..."
        Write-Debug "`tProperty = $($_.front.type)"
        $type = $_.front.type
        Write-Debug "`tValue = $type"

        Write-Debug "Parsing uniqueness..."
        Write-Debug "`tProperty = $($_.front.uniqueness)"
        $uniqueness = $_.front.uniqueness
        Write-Debug "`tValue = $uniqueness"

        $line =
        switch ($type) {
            "Admiral's Order" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set$icons\n\nText: $gametext`""
            }
            "Character" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\nPower: $power Ability: $ability\nDeploy: $deploy Forfeit: $forfeit$icons\n\nLore: $lore\n\nText: $gametext`""
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
                "card `"$image`" `"$title ($rarity)\n$side $type- $subType [$rarity]\nSet: $set\nPower: $power $defenseValue\nDeploy: $deploy Forfeit: $forfeit$icons\n\nLore: $lore\n\nText: $gametext`""
            }
            "Defensive Shield" {
                "card `"/$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
            }
            "Device" {
                "card `"$image`" `"$title ($rarity)\n$side $type [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
            }
            "Effect" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
            }
            "Epic Event" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Game Aid" {
                Write-Warning "Type = $Type, Title = $Title, Warning = Game Aid text needs formatting."
                "card `"$image`" `"$title ($destiny)\n$side $type [$rariry]\nSet: $set\nText: $text`""
            }
            "Interrupt" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subtype [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
            }
            "Jedi Test #1" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Jedi Test #2" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Jedi Test #3" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Jedi Test #4" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Jedi Test #5" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Jedi Test #6" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set\n\nText: $gametext`""
            }
            "Location" {
                Write-Warning "Type = $Type, Title = $Title, Warning = Add \n\n between LIGHT and DARK text."
                if ($uniqueness -contains "*") {
                    $uniqueness = ""
                }
                "card `"$image`" `"$uniqueness$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set$icons\n\nText:\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Objective" {
                Write-Warning "Type = $Type, Title = $Title, Warning = Add \n\n between FRONT and BACK text."
                "card `"/TWOSIDED$image`" `"$title (0/7)\n$side $type [$rarity]\nSet: $set$icons\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Podracer" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set$icons\n\nLore: $lore\n\nText: $gametext`""
            }
            "Starship" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\nPower: $power Armor: $armor Hyperspeed: $hyperspeed\nDeploy: $deploy Forfeit: $forfeit$icons\n\nLore: $lore\n\nText: $gametext`""
            }
            "Vehicle" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\nPower: $power Armor: $armor Landspeed: $landspeed\nDeploy: $deploy Forfeit: $forfeit$icons\n\nLore: $lore\n\nText: $gametext`""
            }
            "Weapon" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
            }
            default {
                Write-Warning "Type = $Type, Title = $Title, Error = Card type not supported."
            }
        }
        $cdf = [PSCustomObject]@{
            Type    = $type
            SubType = $subType
            Title   = $titleSort
            Line    = $line
        }
        Write-Output $cdf
    } |
    Sort-Object -Property "Type", "SubType", "Title" |
    ForEach-Object {
        if ($subTypeGroup -ne $_.SubType) {
            $section = [PSCustomObject]@{
                Type    = $_.Type
                SubType = $_.SubType
                Title   = $_.Title
                Line    = $("`n`[{0} - {1}`]`n" -f $_.Type, $_.SubType).Replace(" - ]", "]")
            }
            Write-Output $section
            $subTypeGroup = $_.SubType
        }
        Write-Output $_
    } |
    Select-Object -ExpandProperty "Line" |
    Set-Content -Path $CdfPath
}

Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Measure-Command {
    ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" # -Debug -Verbose
    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" # -Debug -Verbose

    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -IdFilter 3 # -Debug -Verbose
    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -IdFilter 5300 # -Debug -Verbose

    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -SetFilter "*13*" # -Debug -Verbose
    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -SetFilter "*13*" # -Debug -Verbose

    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TitleFilter "*Rebel Leadership*" # -Debug -Verbose
    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TitleFilter "*Rebel Leadership*" # -Debug -Verbose

    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TypeFilter "Creature" # -Debug -Verbose
    # ExportToCdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TypeFilter "Creature" # -Debug -Verbose
}

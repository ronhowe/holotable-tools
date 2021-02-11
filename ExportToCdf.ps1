Import-Module .\HolotableTools.psm1 -Force
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

    $version = "version {0}" -f $(Get-Date -Format "yyyyMMdd")

    Add-Content -Path $CdfPath -Value $version

    $back = "back foo.gif"

    Add-Content -Path $CdfPath -Value $back

    $subTypeGroup = ""

    $json = Get-Content -Path $JsonPath | ConvertFrom-Json

    $json.cards |
    Where-Object {
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
    } |
    ForEach-Object {
        Write-Verbose "Parsing id = $($_.id), title = $($_.front.title)..."

        $id = $_.id
        $ability = $_.front.ability
        $armor = $_.front.armor
        $deploy = $_.front.deploy
        $destiny = $_.front.destiny
        $extraText = $_.front.extraText
        if ($extraText) {
            $extraText = " $extraText"
        }
        $forfeit = $_.front.forfeit
        $gametext = ConvertTo-CdfGameText -GameText $_.front.gametext -DarkSideIcons $_.front.darkSideIcons -LightSideIcons $_.front.lightSideIcons
        $hyperspeed = $_.front.hyperspeed
        $icon = ConvertTo-CdfIcon -Icons $_.front.icons
        $iconTag = ConvertTo-CdfIconTag -Icons $icons

        $image = ConvertTo-CdfImage -ImageUrl $_.front.imageUrl
        $landspeed = $_.front.landspeed
        $lore = $_.front.lore
        $power = $_.front.power
        $rarity = $_.rarity
        $set = $_.set
        $side = $_.side
        $subType = $_.front.subType
        $title = ConvertTo-CdfTitle -Title $_.front.title
        $sortTitle = ConvertTo-CdfTitleSort -Title $_.front.title
        $type = $_.front.type
        $uniqueness = $_.front.uniqueness
        $section = ConvertTo-CdfSection -Type $type -SubType $subType

        $line =
        switch ($type) {
            "Admiral's Order" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set$icons\n\nText: $gametext`""
            }
            "Character" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\nPower: $power Ability: $ability$extraText\nDeploy: $deploy Forfeit: $forfeit$icons\n\nLore: $lore\n\nText: $gametext`""
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
                if ($uniqueness -contains "*") {
                    $uniqueness = ""
                }
                "card `"$image`" `"$uniqueness$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set$icons\n\nText:\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Objective" {
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
            Section = $section
            Type    = $type
            Title   = $sortTitle
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
                Line    = $("`n`{0}`n" -f $section2)
            }
            Write-Output $section
            $subTypeGroup = $_.SubType
        }
        Write-Output $_
    } |
    Select-Object -ExpandProperty "Line" |
    Add-Content -Path $CdfPath
}

Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

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

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

    "version {0}" -f $(Get-Date -Format "yyyyMMdd") | Add-Content -Path $CdfPath

    if ($CdfPath.EndsWith("Dark.cdf")) {
        "back imp.gif" | Add-Content -Path $CdfPath
    }
    elseif ($CdfPath.EndsWith("Light.cdf")) {
        "back reb.gif" | Add-Content -Path $CdfPath
    }
    else {
        "back placeholder.gif" | Add-Content -Path $CdfPath
    }
    
    [string]$PreviousSection = ""

    Get-Content -Path $JsonPath |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards" |
    Where-Object {
        if ($PSCmdlet.ParameterSetName -eq "NoFilter") {
            $_.legacy -eq $false
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
function ConvertTo-CdfGameText {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        if ($Context.front.gametext) {
            $output = $Context.front.gametext.Replace("Dark:  ", "DARK ($DarkSideIcons): ").Replace("Light:  ", "LIGHT ($LightSideIcons): ")
        }
    }
    catch {
        Write-Error "FAILED TO PARSE GAMETEXT"
        Write-Host $Context -ForegroundColor Red
        $output = "FAILED TO PARSE GAMETEXT"
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

function ConvertTo-CdfIconTag {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $icons = ConvertTo-CdfIcons -Context $Context

    if ($icons) {
        $output = "\nIcons: $icons"
    }

    Write-Output $output
}

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

function ConvertTo-CdfLine {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";
    $id = $Context.id

    try {
        $ability = $Context.front.ability
        $armor = $Contextfront.armor
        $deploy = $Context.front.deploy
        $destiny = $Context.front.destiny
        $extraText = $Context.front.extraText
        if ($extraText) {
            $extraText = " $extraText"
        }
        $forfeit = $Context.front.forfeit
        $gametext = ConvertTo-CdfGameText -Context $Context
        $hyperspeed = $Context.front.hyperspeed
        $icons = ConvertTo-CdfIcons -Context $Context
        $iconTag = ConvertTo-CdfIconTag -Context $Context
        $image = ConvertTo-CdfImage -Context $Context
        $landspeed = $Context.front.landspeed
        $lore = $Context.front.lore
        $power = $Context.front.power
        $rarity = $Context.rarity
        $set = $Context.set
        $side = $Context.side
        $subType = $Context.front.subType
        $title = ConvertTo-CdfTitle -Context $Context
        # $titleSort = ConvertTo-CdfTitleSort -Context $Context
        $type = $Context.front.type
        $uniqueness = $Context.front.uniqueness
        # $section = ConvertTo-CdfSection -Context $Context

        $output =
        switch ($type) {
            "Admiral's Order" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set$iconTag\n\nText: $gametext`""
            }
            "Character" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set\nPower: $power Ability: $ability$extraText\nDeploy: $deploy Forfeit: $forfeit$iconTag\n\nLore: $lore\n\nText: $gametext`""
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
                "card `"$image`" `"$title ($rarity)\n$side $type- $subType [$rarity]\nSet: $set\nPower: $power $defenseValue\nDeploy: $deploy Forfeit: $forfeit$iconTag\n\nLore: $lore\n\nText: $gametext`""
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
                "card `"$image`" `"$uniqueness$title ($destiny)\n$side $type - $subType [$rarity]\nSet: $set$iconTag\n\nText:\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Objective" {
                "card `"/TWOSIDED$image`" `"$title (0/7)\n$side $type [$rarity]\nSet: $set$iconTag\n{TODO: EDIT GAME TEXT}$gametext`""
            }
            "Podracer" {
                "card `"$image`" `"$title ($destiny)\n$side $type [$rarity]\nSet: $set$iconTag\n\nLore: $lore\n\nText: $gametext`""
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
                Write-Warning "Type = $type, Title = $title, Error = Card type not supported."
            }
        }
    }
    catch {
        Write-Host "FAILED TO PARSE $id" -ForegroundColor Red
        Write-Host $_.Exception.Message
        $output = "FAILED TO PARSE $id"
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

    if ($Context.front.subType) {
        $output = $("[{0} - {1}]" -f $Context.front.type, $Context.front.subType.Split(":")[0]).Replace(" - ]", "]")
    }
    else {
        $output = "[{0}]" -f $Context.front.type
    }

    Write-Output $output
}

function ConvertTo-CdfTitle {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.title.Replace("<>", "")

    Write-Output $output
}


function ConvertTo-CdfTitleSort {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.title.Replace("<>", "").Replace("•", "")

    Write-Output $output
}

# function Get-JsonById {
#     param (
#         [Parameter(Mandatory = $true)]
#         [int]
#         $Id,

#         [ValidateSet("Dark", "Light")]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $Side,

#         [ValidateScript( { Test-Path -Path $_ -PathType "Container" })]
#         [string]
#         $RepoPath = "~/source/repos/swccg-card-json"
#     )

#     $JsonPath = Join-Path -Path $RepoPath -ChildPath "$Side.json"

#     Get-Content -Path $JsonPath |
#     ConvertFrom-Json |
#     Select-Object -ExpandProperty "cards" |
#     Where-Object { $_.id -eq $Id }
# }

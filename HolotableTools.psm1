function ConvertTo-CdfGameText {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    try {
        $output = $Context.front.gametext.Replace("Dark:  ", "DARK ($DarkSideIcons): ").Replace("Light:  ", "LIGHT ($LightSideIcons): ").Replace("•", "�")
    }
    catch {
        Write-Warning "Failed to parse gametext."
        $output = "TODO"
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
        # $iconTag = ConvertTo-CdfIconTag -Icons $icons
        $image = ConvertTo-CdfImage -Context $Context
        $landspeed = $Context.front.landspeed
        $lore = $Context.front.lore
        $power = $Context.front.power
        $rarity = $Context.rarity
        $set = $Context.set
        $side = $Context.side
        $subType = $Context.front.subType
        $title = ConvertTo-CdfTitle -Context $Context
        $titleSort = ConvertTo-CdfTitleSort -Context $Context
        $type = $Context.front.type
        $uniqueness = $Context.front.uniqueness
        $section = ConvertTo-CdfSection -Context $Context


        $output =
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
            "Interupt" {
                "card `"$image`" `"$title ($destiny)\n$side $type - $subtype [$rarity]\nSet: $set\n\nLore: $lore\n\nText: $gametext`""
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

    $output = $Context.front.title.Replace("<>", "").Replace("•", "�")

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

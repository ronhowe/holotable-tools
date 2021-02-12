Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

BeforeAll {
    $Dark = Get-Content -Path "~/source/repos/swccg-card-json/Dark.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards"

    $Light = Get-Content -Path "~/source/repos/swccg-card-json/Light.json" |
    ConvertFrom-Json |
    Select-Object -ExpandProperty "cards"

    # Suppress PSScriptAnalyzer(PSUseDeclaredVarsMoreThanAssignments)
    @($Dark, $Light) | Out-Null
}

Describe "ConvertTo-CdfGameText" {
    Context "When GameText Contains •" {
        It "Should Replace • With �" {
            # Coruscant-Dark/large/beginlandingyourtroops
            $Dark.Where( { $_.id -eq 216 }) |
            ConvertTo-CdfGameText |
            Should -Be "Deploy on table. Your unique (�) Republic characters are forfeit +2 and immune to Goo Nee Tay. Unless Imperial Arrest Order on table, once during your deploy phase, may deploy one docking bay from Reserve Deck; reshuffle. (Immune to Alter.)"
        }
    }

    Context "When GameText Is Missing" {
        It "Should Return Empty GameText" {
            # JediPack-Dark/large
            $Dark.Where( { $_.id -eq 2424 }) |
            ConvertTo-CdfGameText |
            Should -Be ""
        }
    }
}

Describe "ConvertTo-CdfImage" {
    Context "When ImageUrl Is Normal" {
        It "Should Parse ImageUrl" {
            # Coruscant-Dark/large/beginlandingyourtroops
            $Dark.Where( { $_.id -eq 216 }) |
            ConvertTo-CdfImage |
            Should -Be "/starwars/Coruscant-Dark/t_beginlandingyourtroops"
        }
    }
}

Describe "ConvertTo-CdfIcons" {
    Context "When Multiple Icons Exist" {
        It "Should Concatenate Icons" {
            # Premiere-Dark/large/darthvader
            $Dark.Where( { $_.id -eq 634 }) |
            ConvertTo-CdfIcons |
            Should -Be "Pilot, Warrior"
        }
    }
}

Describe "ConvertTo-CdfSection" {
    Context "When SubType Is Simple" {
        It "Should Parse" {
            # Premiere-Dark/large/alderaan
            $Dark.Where( { $_.id -eq 79 }) |
            ConvertTo-CdfSection |
            Should -Be "[Location - System]"
        }
    }
    Context "When SubType Is Complex" {
        It "Should Parse" {
            # Dagobah-Dark/large/ig2000
            $Dark.Where( { $_.id -eq 1244 }) |
            ConvertTo-CdfSection |
            Should -Be "[Starship - Starfighter]"
        }
    }
}

Describe "ConvertTo-CdfTitle" {
    Context "When Title Contains <>" {
        It "Should Remove <>" {
            # Dagobah-Dark/large/asteroidfield
            $Dark.Where( { $_.id -eq 148 }) |
            ConvertTo-CdfTitle |
            Should -Be "Asteroid Field"
        }
    }
    Context "When Title Contains•" {
        It "Should Replace • With �" {
            # Dagobah-Dark/large/3720to1
            $Dark.Where( { $_.id -eq 4 }) |
            ConvertTo-CdfTitle |
            Should -Be "�3,720 To 1"
        }
    }
}

Describe "ConvertTo-CdfTitleSort" {
    Context "When Title Contains <>" {
        It "Should Remove <>" {
            # Dagobah-Dark/large/asteroidfield
            $Dark.Where( { $_.id -eq 148 }) |
            ConvertTo-CdfTitleSort |
            Should -Be "Asteroid Field"
        }
    }
    Context "When Title Contains •" {
        It "Should Remove •" {
            # Dagobah-Dark/large/3720to1
            $Dark.Where( { $_.id -eq 4 }) |
            ConvertTo-CdfTitleSort |
            Should -Be "3,720 To 1"
        }
    }
}

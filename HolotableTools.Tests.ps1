Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name ".\HolotableTools.psm1" -Force

Describe "ConvertTo-CdfGameText" {
    Context "When GameText Is Normal" {
        It "Should Return GameText" {
            ConvertTo-CdfGametext -GameText "test" |
            Should -Be "test"
        }
        Context "When GameText Contains •" {
            It "Should Replace • With �" {
                ConvertTo-CdfGametext -GameText "•3,720 To 1" |
                Should -Be "�3,720 To 1"
            }
        }
        Context "When GameText Contains ’" {
            It "Should Replace ’ With '" {
                ConvertTo-CdfGametext -GameText "’3,720 To 1" |
                Should -Be "'3,720 To 1"
            }
        }
    }
}
Describe "ConvertTo-CdfIcon" {
    Context "when normal" {
        It "should format section" {
            ConvertTo-CdfIcon -Icons @("Death Star II", "Endor") |
            Should -Be "Death Star II, Endor"
        }
    }
}
Describe "ConvertTo-CdfIconTag" {
    Context "when normal" {
        It "should format section" {
            ConvertTo-CdfIconTag -Icons "Death Star II" |
            Should -Be "Icons: Death Star II"
        }
    }
    Context "when empty" {
        It "should return empty" {
            ConvertTo-CdfIconTag -Icons "" |
            Should -Be ""
        }
    }
}

Describe "ConvertTo-CdfImage" {
    Context "when normal" {
        It "should format section" {
            ConvertTo-CdfImage -ImageUrl "https://res.starwarsccg.org/cards/Images-HT/starwars/Dagobah-Dark/large/asteroidfield.gif?raw=true" |
            Should -Be "/starwars/Dagobah-Dark/t_asteroidfield"
        }
    }
}

Describe "ConvertTo-CdfSection" {
    Context "when normal" {
        It "should format section" {
            ConvertTo-CdfSection -Type "Location" -SubType "System" |
            Should -Be "[Location - System]"
        }
    }
    Context "when subtype is complex" {
        It "should format section" {
            ConvertTo-CdfSection -Type "Starship" -SubType "Starfighter: Trilon Aggressor" |
            Should -Be "[Starship - Starfighter]"
        }
    }
}

Describe "ConvertTo-CdfTitle" {
    Context "when title contains <>" {
        It "should remove <>" {
            ConvertTo-CdfTitle -Title "<><><>Asteroid Field" |
            Should -Be "Asteroid Field"
        }
        Context "when title contains •" {
            It "Should replace • with �" {
                ConvertTo-CdfTitle -Title "•3,720 To 1" |
                Should -Be "�3,720 To 1"
            }
        }
    }
}

Describe "ConvertTo-CdfTitleSort" {
    Context "when title contains <>" {
        It "should remove <>" {
            ConvertTo-CdfTitleSort -Title "<><><>Asteroid Field" | Should -Be "Asteroid Field"
        }
        Context "when title contains •" {
            It "should remove •" {
                ConvertTo-CdfTitleSort -Title "•3,720 To 1" | Should -Be "3,720 To 1"
            }
        }
    }
}

#region Hit F5

Clear-Host

Push-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

#region Dark

Write-Host "Exporting Dark.cdf..."
Export-Cdf -CardJsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -SetJsonPath "~/source/repos/ronhowe/swccg-card-json/sets.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -ExcludeLegacy

Write-Host "Exporting Dark.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Dark.basic.cdf" -ExcludeLegacy

Write-Host "Exporting darkside.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/darkside.basic.cdf" -ExcludeLegacy

Write-Host "Diffing darkside.basic.cdf vs Dark.basic.cdf..."
code --diff ./darkside.basic.cdf ./Dark.basic.cdf

#endregion #Dark

#region Light

Write-Host "Exporting Light.cdf..."
Export-Cdf -CardJsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -SetJsonPath "~/source/repos/ronhowe/swccg-card-json/sets.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -ExcludeLegacy

Write-Host "Exporting Light.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Light.basic.cdf" -ExcludeLegacy

Write-Host "Exporting lightside.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/lightside.basic.cdf" -ExcludeLegacy

Write-Host "Diffing lightside.basic.cdf vs Light.basic.cdf..."
code --diff ./lightside.basic.cdf ./Light.basic.cdf

#endregion Light

#region Statistics

Write-Host "Getting card statistics..."

Get-Content -Path "~/source/repos/ronhowe/swccg-card-json/Dark.json" | ConvertFrom-Json | Select-Object -ExpandProperty "cards" | Measure-Object -Property id -Minimum -Maximum | Select-Object -Property @{Name = "Side"; Expression = { "Dark" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }

Get-Content -Path "~/source/repos/ronhowe/swccg-card-json/Light.json" | ConvertFrom-Json | Select-Object -ExpandProperty "cards" | Measure-Object -Property id -Minimum -Maximum | Select-Object -Property @{Name = "Side"; Expression = { "Light" } }, @{Name = "Total Cards"; Expression = { $_.Count } }, @{Name = "Minimum Id"; Expression = { $_.Minimum } }, @{Name = "Maximum Id"; Expression = { $_.Maximum } }

#endregion Statistics

Pop-Location

Write-Host "Done." -ForegroundColor Green

#endregion Hit F5

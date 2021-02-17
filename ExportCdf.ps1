#region Hit F5

Clear-Host

Push-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

Write-Host "Exporting Dark.cdf..."
Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -ExcludeLegacy
Write-Host "Exporting darkside.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Dark.basic.cdf" -ExcludeLegacy
Write-Host "Diffing darkside.basic.cdf vs Dark.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/darkside.basic.cdf" -ExcludeLegacy
Write-Host "Exporting Dark.basic.cdf..."
code --diff ./darkside.basic.cdf ./Dark.basic.cdf

Write-Host "Exporting Light.cdf..."
Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -ExcludeLegacy
Write-Host "Exporting lightside.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Light.basic.cdf" -ExcludeLegacy
Write-Host "Diffing lightside.basic.cdf vs Light.basic.cdf..."
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/lightside.basic.cdf" -ExcludeLegacy
Write-Host "Exporting Light.basic.cdf..."
code --diff ./lightside.basic.cdf ./Light.basic.cdf

Pop-Location

Write-Host "Done." -ForegroundColor Green

#endregion Hit F5

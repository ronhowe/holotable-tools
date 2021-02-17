#region Hit F5

Clear-Host

Write-Host "Export started.  Please wait." -ForegroundColor Green

Push-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -ExcludeLegacy:$true
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/darkside.basic.cdf" -ExcludeLegacy:$true
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Dark.basic.cdf" -ExcludeLegacy:$true
code --diff ./darkside.basic.cdf ./Dark.basic.cdf

Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -ExcludeLegacy:$true
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/lightside.basic.cdf" -ExcludeLegacy:$true
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Light.basic.cdf" -ExcludeLegacy:$true
code --diff ./lightside.basic.cdf ./Light.basic.cdf

Pop-Location

Write-Host "Export completed." -ForegroundColor Green

#endregion Hit F5

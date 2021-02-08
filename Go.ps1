Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

./ExportToCdf.ps1 -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "./Dark.cdf" -Set "Virtual Set 13" -Verbose

./ExportToCdf.ps1 -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "./Light.cdf" -Set "Virtual Set 13" -Verbose

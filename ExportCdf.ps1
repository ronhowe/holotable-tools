#region Hit F5

Clear-Host

# TODO : Remove when done iterating.
Push-Location -Path "~/source/repos/ronhowe/holotable" ; git pull origin consistency ; Pop-Location

Write-Host "Exporting..."

Push-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

$seconds = Measure-Command -Expression {
    Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf"
    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf"

    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -IdFilter 6535 -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -IdFilter 5300 -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -SetFilter "*13*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -SetFilter "*13*" -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -TitleFilter "*Coruscant: Imperial City*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -TitleFilter "*Rebel Leadership*" -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Dark.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -TypeFilter "Objective*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/ronhowe/swccg-card-json/Light.json" -CdfPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -TypeFilter "Admiral's*" -Debug -Verbose
} | Select-Object -ExpandProperty "Seconds"

Write-Host "Export completed in $seconds seconds." -ForegroundColor Green

Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/darkside.basic.cdf" -ExcludeLegacy
Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Dark.basic.cdf" -ExcludeLegacy

# Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/Lightside.basic.cdf"
# Export-BasicCdf -CdfInputPath "~/source/repos/ronhowe/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/ronhowe/holotable-tools/lightside.basic.cdf"

code --diff darkside.basic.cdf Dark.basic.cdf

#endregion Hit F5

Pop-Location

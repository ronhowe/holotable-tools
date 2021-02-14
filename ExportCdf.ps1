#region Hit F5

Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

$seconds = Measure-Command -Expression {
    Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf"
    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf"

    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -IdFilter 312 -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -IdFilter 5300 -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -SetFilter "*13*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -SetFilter "*13*" -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TitleFilter "*A Bright Center*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TitleFilter "*Rebel Leadership*" -Debug -Verbose

    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TypeFilter "Admiral's*" -Debug -Verbose
    # Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TypeFilter "Admiral's*" -Debug -Verbose
} | Select-Object -ExpandProperty "Seconds"

Write-Host "Export completed in $seconds seconds." -ForegroundColor Green

# Export-BasicCdf -CdfInputPath "~/source/repos/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/darkside.basic.cdf" -ExcludeLegacy
Export-BasicCdf -CdfInputPath "~/source/repos/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Dark.basic.cdf" -ExcludeLegacy

# Export-BasicCdf -CdfInputPath "~/source/repos/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Lightside.basic.cdf"
# Export-BasicCdf -CdfInputPath "~/source/repos/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/lightside.basic.cdf"

#endregion Hit F5

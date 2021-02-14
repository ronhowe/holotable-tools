#region Hit F5

Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf"
# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf"

# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -IdFilter 312
# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -IdFilter 5300

# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -SetFilter "*Dagobah*"
# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -SetFilter "*13*"

# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TitleFilter "*A Bright Center*"
# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TitleFilter "*Rebel Leadership*"

# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TypeFilter "Location*"
# Export-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TypeFilter "Admiral*"

# Export-BasicCdf -CdfInputPath "~/source/repos/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/darkside.basic.cdf"
Export-BasicCdf -CdfInputPath "~/source/repos/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Dark.basic.cdf"

# Export-BasicCdf -CdfInputPath "~/source/repos/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Lightside.basic.cdf"
# Export-BasicCdf -CdfInputPath "~/source/repos/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/lightside.basic.cdf"

#endregion Hit F5

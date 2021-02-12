#region
Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force
#endregion

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -IdFilter 3 -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -IdFilter 5300  -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -SetFilter "*Dagobah*"
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -SetFilter "*13*"  -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TitleFilter "*Darth Vader*"  -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TitleFilter "*Rebel Leadership*"  -Debug -Verbose

ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TypeFilter "Admiral*" -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TypeFilter "Creature" -Debug -Verbose

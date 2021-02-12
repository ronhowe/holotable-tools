Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -IdFilter 3 -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -IdFilter 5300 # -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -SetFilter "*Dagobah*"
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -SetFilter "*13*" # -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TitleFilter "*Darth Vader*" # -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TitleFilter "*Rebel Leadership*" # -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/swccg-card-json/Dark.cdf" -TypeFilter "Admiral*" # -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/swccg-card-json/Light.cdf" -TypeFilter "Creature" # -Debug -Verbose

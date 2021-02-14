#region Click Run
Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" #-Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" #-Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -IdFilter 312 #-Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -IdFilter 5300  #-Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -SetFilter "*Dagobah*"
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -SetFilter "*13*"  -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TitleFilter "*A Bright Center*"  -Debug -Verbose
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TitleFilter "*Rebel Leadership*"  -Debug -Verbose

# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Dark.json" -CdfPath "~/source/repos/holotable-tools/Dark.cdf" -TypeFilter "Location*"
# ConvertTo-Cdf -JsonPath "~/source/repos/swccg-card-json/Light.json" -CdfPath "~/source/repos/holotable-tools/Light.cdf" -TypeFilter "Admiral*" -Debug -Verbose

# SortAndSave -CdfInputPath "~/source/repos/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/darkside.sorted.cdf"
SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Dark.sorted.cdf"

# SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Light.sorted.cdf"
# SortAndSave -CdfInputPath "~/source/repos/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/lightside.sorted.cdf"
#endregion Click Run
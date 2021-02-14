Clear-Host

Set-Location -Path $(Split-Path -Path $MyInvocation.MyCommand.Path -Parent)

Import-Module -Name "./HolotableTools.psm1" -Force

SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Dark.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Dark.sorted.cdf"
SortAndSave -CdfInputPath "~/source/repos/holotable/darkside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/darkside.sorted.cdf"

SortAndSave -CdfInputPath "~/source/repos/holotable-tools/Light.cdf" -CdfOutputPath "~/source/repos/holotable-tools/Light.sorted.cdf"
SortAndSave -CdfInputPath "~/source/repos/holotable/lightside.cdf" -CdfOutputPath "~/source/repos/holotable-tools/lightside.sorted.cdf"

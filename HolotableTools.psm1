function ConvertTo-CdfGameText {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.gametext.Replace("Dark:  ", "DARK ($DarkSideIcons): ").Replace("Light:  ", "LIGHT ($LightSideIcons): ").Replace("•", "�")

    Write-Output $output
}

function ConvertTo-CdfIcons {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    foreach ($icon in $Context.front.icons) { $output = $output + "$icon, " } ; $output = $output.Trim().Trim(",")

    Write-Output $output
}

function ConvertTo-CdfImage {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.imageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")

    Write-Output $output
}

function ConvertTo-CdfSection {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $("[{0} - {1}]" -f $Context.front.type, $Context.front.subType.Split(":")[0]).Replace(" - ]", "]")

    Write-Output $output
}

function ConvertTo-CdfTitle {
    param(
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.title.Replace("<>", "").Replace("•", "�")

    Write-Output $output
}


function ConvertTo-CdfTitleSort {
    param (
        [Parameter(ValueFromPipeline = $true)]
        [PSCustomObject]
        $Context
    )

    [string]$output = "";

    $output = $Context.front.title.Replace("<>", "").Replace("•", "")

    Write-Output $output
}

# function Get-JsonById {
#     param (
#         [Parameter(Mandatory = $true)]
#         [int]
#         $Id,

#         [ValidateSet("Dark", "Light")]
#         [Parameter(Mandatory = $true)]
#         [string]
#         $Side,

#         [ValidateScript( { Test-Path -Path $_ -PathType "Container" })]
#         [string]
#         $RepoPath = "~/source/repos/swccg-card-json"
#     )

#     $JsonPath = Join-Path -Path $RepoPath -ChildPath "$Side.json"

#     Get-Content -Path $JsonPath |
#     ConvertFrom-Json |
#     Select-Object -ExpandProperty "cards" |
#     Where-Object { $_.id -eq $Id }
# }

function ConvertTo-CdfTitle {
    param (
        [Parameter()]
        [string]
        $Title
    )

    $output = $Title.Replace("<>", "").Replace("•", "�")

    Write-Output $output
}

function ConvertTo-CdfTitleSort {
    param (
        [Parameter()]
        [string]
        $Title
    )

    $output = $Title.Replace("<>", "").Replace("•", "")

    Write-Output $output
}

function ConvertTo-CdfSection {
    param (
        [Parameter()]
        [string]
        $Type,

        [Parameter()]
        [string]
        $SubType
    )

    $output = $("[{0} - {1}]" -f $Type, $SubType.Split(":")[0]).Replace(" - ]", "]")

    Write-Output $output
}

function ConvertTo-CdfImage {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ImageUrl
    )

    $output = $ImageUrl.Replace("https://res.starwarsccg.org/cards/Images-HT", "").Replace("cards/", "").Replace("large/", "t_").Replace(".gif?raw=true", "")

    Write-Output $output
}

function ConvertTo-CdfGameText {
    param(
        [string]
        $GameText,

        [int]
        $DarkSideIcons,

        [int]
        $LightSideIcons
    )

    $output = ""

    $output = $GameText.Replace("Dark:  ", "DARK ($DarkSideIcons): ").Replace("Light:  ", "LIGHT ($LightSideIcons): ").Replace("’", "'").Replace("•", "�")

    Write-Output $output
}
function ConvertTo-CdfIconTag {
    param(
        [string]
        $Icons
    )

    $output = ""

    if ($Icons -ne "") {
        $output = "Icons: $Icons"
    }

    Write-Output $output
}

function ConvertTo-CdfIcon {
    [CmdletBinding()]
    param (
        [Parameter()]
        [string[]]
        $Icons
    )

    $output = ""

    foreach ($icon in $Icons) { $output = $output + "$icon, " } ; $output = $output.Trim().Trim(",")

    Write-Output $output
}
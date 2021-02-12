Get-Content -Path "~/source/repos/holotable/darkside.cdf" |
ForEach-Object {
    if ($_ -ne "") {
        $count = 0
    }
    else {
        $count++
    }
 
    if ($count -lt 2) {
        if (-not ($_.StartsWith("card `"/legacy"))) {
            Write-Output $_
        }
    }
} |
Set-Content -Path "~/source/repos/holotable/darkside2.cdf" -Encoding utf8

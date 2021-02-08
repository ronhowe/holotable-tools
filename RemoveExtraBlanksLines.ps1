$Cdf = Get-Content /home/ronhowe/source/repos/holotable/lightside.cdf

$Cdf |
ForEach-Object {
    if ($_ -ne "") {
        $count = 0
    }
    else {
        $count++
    }
 
    if ($count -lt 2) {
        Write-Output $_
    }
} |
Set-Content /home/ronhowe/source/repos/holotable/lightside.cdf

function Get-Something {    
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]
        $ThingToGet
    )

    if ($PSBoundParameters.ContainsKey('ThingToGet')) {
        Write-Output "I got something!"  # This will make the Pester test fail
    }
    else {
        Write-Output "I got something!"
    }
}
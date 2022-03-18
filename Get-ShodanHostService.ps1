#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanHostService {
    [CmdletBinding(
        DefaultParameterSetName = 'Direct'
    )]
    Param
    (
        [Parameter(Mandatory)]
        [string]
        $IPAddress,

        # All historical banners should be returned.
        [switch]
        $History,

        # Only return the list of ports and the general host information, no banners
        [switch]
        $Minify,

        # Shodan developer API key
        [String]
        $ApiKey,

        [String]
        $CertificateThumbprint,

        [Parameter(Mandatory, ParameterSetName = 'Proxy')]
        [String]
        $Proxy,

        [Parameter(ParameterSetName = 'Proxy')]
        [Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter(ParameterSetName = 'Proxy')]
        [Switch]
        $ProxyUseDefaultCredentials
    )
    begin {
        $Body = @{}
        if ($PSBoundParameters.ContainsKey('History') -and ($History -eq $true)) {
            $Body['history'] = 'True'
        }
        if ($PSBoundParameters.ContainsKey('Minify') -and ($Minify -eq $true)) {
            $Body['minify'] = 'True'
        }
        $InvokeParameters = @{
            'Method'     = 'GET'
            'Uri'        = "https://api.shodan.io/shodan/host/$($IPAddress)"
            'PSTypeName' = 'Shodan.Host.Info'
            'Body'       = $Body
        }
        $InvokeParameters = Add-ShodanPassthroughParameter -FromHashtable $PSBoundParameters -ToHashTable $InvokeParameters
    }
    process {
        Invoke-ShodanRestMethod @InvokeParameters
    }
    end {
    }
}

#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanDnsReverse {
    [CmdletBinding(
        DefaultParameterSetName = 'Direct'
    )]
    param (
        # List of IP Addresses to resolve
        [Parameter(Mandatory)]
        [string[]]
        $IPAddress,

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
        $InvokeParameters = @{
            'Method'     = 'GET'
            'Uri'        = 'https://api.shodan.io/dns/reverse'
            'PSTypeName' = 'Shodan.DNS.Reverse'
            'Body'       = @{
                'ips' = ($IPAddress -join ',')
            }
        }
        $InvokeParameters = Add-ShodanPassthroughParameter -FromHashtable $PSBoundParameters -ToHashTable $InvokeParameters
    }
    process {
        Invoke-ShodanRestMethod @InvokeParameters
    }
    end {
    }
}

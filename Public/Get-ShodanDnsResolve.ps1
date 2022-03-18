#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanDnsResolve {
    [CmdletBinding(
        DefaultParameterSetName = 'Direct'
    )]
    param (
        # Comma-separated list of hostnames ro resolve."
        [Parameter(Mandatory)]
        [string[]]
        $Hostname,

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
            'Uri'        = 'https://api.shodan.io/dns/resolve'
            'PSTypeName' = 'Shodan.DNS.Resolve'
            'Body'       = @{
                'hostnames' = ($Hostname -join ',')
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

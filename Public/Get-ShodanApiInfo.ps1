#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanApiInfo {
    [CmdletBinding(
        DefaultParameterSetName = 'Direct'
    )]
    param (
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
            'Uri'        = 'https://api.shodan.io/api-info'
            'PSTypeName' = 'Shodan.APIKey.Info'
        }
        $InvokeParameters = Add-ShodanPassthroughParameter -FromHashtable $PSBoundParameters -ToHashTable $InvokeParameters
    }
    process {
        Invoke-ShodanRestMethod @InvokeParameters
    }
    end {
    }
}

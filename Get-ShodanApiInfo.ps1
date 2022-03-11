#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanAPIInfo
{
    [CmdletBinding(DefaultParameterSetName = 'Direct')]
    Param
    (
        # Shodan developer API key
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Proxy')]
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Direct')]
        [string]
        $APIKey,

        [Parameter(Mandatory=$false,
                  ParameterSetName = 'Proxy')]
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Direct')]
        [string]
        $CertificateThumbprint,

        [Parameter(Mandatory=$true,
                   ParameterSetName = 'Proxy')]
        [string]
        $Proxy,
 
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Proxy')]
        [Management.Automation.PSCredential]
        $ProxyCredential,

        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Proxy')]
        [Switch]
        $ProxyUseDefaultCredentials
    )

    Begin
    {
        if (!(Test-Path variable:Global:ShodanAPIKey ) -and !($APIKey))
        {
            throw 'No Shodan API Key has been specified or set.'
        }
        elseif ((Test-Path variable:Global:ShodanAPIKey ) -and !($APIKey))
        {
            $APIKey = $Global:ShodanAPIKey
        }

        # Start building parameters for REST Method invokation.
        $Params =  @{}
        $Params.add('Body', @{'key'= $APIKey})
        $Params.add('Method', 'Get')
        $Params.add('Uri',[uri]'https://api.shodan.io/api-info')

        # Check if connection will be made thru a proxy.
        if ($PsCmdlet.ParameterSetName -eq 'Proxy')
        {
            $Params.Add('Proxy', $Proxy)

            if ($ProxyCredential)
            {
                $Params.Add('ProxyCredential', $ProxyCredential)
            }

            if ($ProxyUseDefaultCredentials)
            {
                $Params.Add('ProxyUseDefaultCredentials', $ProxyUseDefaultCredentials)
            }
        }

        # Check if we will be doing certificate pinning by checking the certificate thumprint.
        if ($CertificateThumbprint)
        {
            $Params.Add('CertificateThumbprint', $CertificateThumbprint)
        }
    }
    Process
    {
        $ReturnedObject = Invoke-RestMethod @Params
        if ($ReturnedObject)
        {
            $ReturnedObject.pstypenames.insert(0,'Shodan.APIKey.Info')
            $ReturnedObject
        }
    }
    End
    {
    }
}
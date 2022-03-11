#  .ExternalHelp Posh-Shodan.Help.xml
function Get-ShodanHostService
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

        [Parameter(Mandatory=$true,
                   ParameterSetName = 'Proxy')]
        [Parameter(Mandatory=$true,
                   ParameterSetName = 'Direct')]
        [string]
        $IPAddress,

        # All historical banners should be returned.
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Proxy')]
        [Parameter(Mandatory=$false,
                   ParameterSetName = 'Direct')]
        [switch]
        $History,

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

        $Body = @{'key'= $APIKey; 'ip' = $IPAddress}

        if ($History)
        {
            $Body.add('history','True')
        }

        # Start building parameters for REST Method invokation.
        $Params =  @{}
        $Params.add('Body', $Body)
        $Params.add('Method', 'Get')
        $Params.add('Uri',[uri]"https://api.shodan.io/shodan/host/$($IPAddress)")

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
            $ReturnedObject.pstypenames.insert(0,'Shodan.Host.Info')
            $ReturnedObject
        }
    }
    End
    {
    }
}

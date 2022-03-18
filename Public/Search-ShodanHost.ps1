#  .ExternalHelp Posh-Shodan.Help.xml
function Search-ShodanHost {
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
        $ProxyUseDefaultCredentials,

         # Text to query for.
        [String]
        $Query,

        #  Find devices located in the given city. It's best combined with the
        # 'Country' filter to make sure you get the city in the country you
        # want (city names are not always unique).
        [String]
        $City,

        # Narrow results down by country.
        [String]
        $Country,

        # Latitude and longitude.
        [String]
        $Geo,

        # Search for hosts that contain the value in their hostname.
        [String]
        $Hostname,

        # Limit the search results to a specific IP or subnet. It uses CIDR
        # notation to designate the subnet range.
        [String]
        $Net,

        # Specific operating systems. Common possible values are: windows,
        # linux and cisco.
        [String]
        $OS,

        # Search the HTML of the website for the given value.
        [String]
        $Html,

        # Find devices based on the upstream owner of the IP netblock.
        [String]
        $Isp,

        # The network link type. Possible values are: "Ethernet or modem",
        # "generic tunnel or VPN", "DSL", "IPIP or SIT", "SLIP", "IPSec or
        # "GRE", "VLAN", "jumbo Ethernet", "Google", "GIF", "PPTP", "loopback",
        # "AX.25 radio modem".
        [ValidateSet(
            'Ethernet or modem', 'generic tunnel or VPN', 'DSL',
            'IPIP or SIT', 'SLIP', 'IPSec or GRE', 'VLAN', 'jumbo Ethernet',
            'Google', 'GIF', 'PPTP', 'loopback', 'AX.25 radio modem'
        )]
        [String[]]
        $Link,

        #Find Ntp servers that had the given IP in their monlist.
        [String]
        $Ntp_IP,

        # Find Ntp servers that return the given number of IPs in the initial monlist response.
        [String]
        $Ntp_IP_Count,

        # Find Ntp servers that had IPs with the given port in their monlist.
        [Int]
        $Ntp_Port,

        # Whether or not more IPs were available for the given Ntp server.
        [Switch]
        $Ntp_More,

        # Find devices based on the owner of the IP netblock.
        [String]
        $Org,

        # Filter using the name of the software/ product; ex: product:Apache
        [String]
        $Product,

        # Filter the results to include only products of the given version; ex: product:apache version:1.3.37
        [String]
        $Version,

        # Search the title of the website.
        [String]
        $Title,

        # Port number  to narrow the search to specific services.
        [String]
        $Port,

        # Limit search for data that was collected before the given date in
        # format day/month/year.
        [String]
        $Before,

        # Limit search for data that was collected after the given date in
        # format day/month/year.
        [String]
        $After,

        # The page number to page through results 100 at a time. Overrides the
        # "offset" and "limit" parameters if they were provided (default: 1)
        [Int]
        $Page,

        # The positon from which the search results should be returned (default: 0)
        [Int]
        $Offset,

        # The number of results to be returned default(100)
        [Int]
        $Limit,

        # True or False; whether or not to truncate some of the larger fields (default: True)
        [Bool]
        $Minify = $true,

        # A comma-separated list of properties to get summary information on. Property names
        # can also be in the format of "property:count", where "count" is the number of facets
        # that will be returned for a property (i.e. "country:100" to get the top 100 countries
        # for a search query).
        [String]
        $Facets

    )

    begin {
        $QueryDefinionHash = @{
            'City'         = { "city:'$($City.Trim())'" }
            'Country'      = { "country_name:`'$($Country.Trim())`'" }
            'Geo'          = { "geo:$($Geo.Trim())" }
            'Hostname'     = { "hostname:$($Hostname.Trim())" }
            'Net'          = { "net:$($Net.Trim())" }
            'OS'           = { "os:$($OS.Trim())" }
            'Port'         = { "port:$($Port.Trim())" }
            'Before'       = { "before:$($Before.Trim())" }
            'After'        = { "after:$($After.Trim())" }
            'Html'         = { "html:$($Html.Trim())" }
            'Isp'          = { "isp:`'$($Isp.Trim())`'" }
            'Link'         = { "link:$($Link.join(','))" }
            'Org'          = { "org:$($Org.Trim())" }
            'Ntp_IP'       = { "Ntp.ip:$($Ntp_IP.Trim())" }
            'Ntp_IP_Count' = { "Ntp.ip_count:$($Ntp_IP_Count.Trim())" }
            'Ntp_More'     = { "Ntp.more:$Ntp_More" }
            'Ntp_Port'     = { "Ntp.port:$($Ntp_Port.Trim())" }
            'Title'        = { "title:$($Title.Trim())" }
            'Version'      = { "version:$($Version.Trim())" }
            'Product'      = { "product:$($Product.Trim())" }
        }
        if ($PSBoundParameters.ContainsKey('Query') -and ('' -ne $Query) -and ($null -ne $Query)) {
            $LocalQuery = @( $Query )
        }
        else {
            $LocalQuery = @()
        }
        $QueryArray = foreach ($QueryDefinion in $QueryDefinionHash.GetEnumerator()) {
            if ($PSBoundParameters.ContainsKey($QueryDefinion.Key)) {
                Invoke-Command -ScriptBlock $QueryDefinion.Value
            }
        }
        $LocalQuery += $QueryArray
        $Body = @{
            'query' = ($LocalQuery -join ' ')
        }
        if ($PSBoundParameters.ContainsKey('Minify') -and ($Minify -eq $true)) {
            $Body['minify'] = 'True'
        }
        $InvokeParameters = @{
            'Method'     = 'GET'
            'Uri'        = 'https://api.shodan.io/shodan/host/search'
            'Body'       = $Body
        }
        $InvokeParameters = Add-ShodanPassthroughParameter -FromHashtable $PSBoundParameters -ToHashTable $InvokeParameters
    }
    process {
        $ReturnedObject = Invoke-RestMethod @InvokeParameters
        if ($ReturnedObject) {
            if ($ReturnedObject.Total -ne 0) {
                $FixedMatches = foreach ($Match in $ReturnedObject.Matches) {
                    $Match.PSTypeNames.Insert(0, 'Shodan.Host.Match')
                }
                [PSCustomObject]$SearchObject = [Ordered]@{
                    'Total'   = $ReturnedObject.Total
                    'Matches' = $FixedMatches
                    'Facets'  = $ReturnedObject.Facets
                }
                $SearchObject.PSTypeNames.Insert(0, 'Shodan.Host.Search')
                $SearchObject
            }
            else {
                Write-Warning -Message 'No matches found.'
            }
        }
    }
    end {
    }
}
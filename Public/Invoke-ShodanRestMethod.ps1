function Invoke-ShodanRestMethod {
    [CmdletBinding(DefaultParameterSetName = 'Direct')]
    param (
        # Shodan developer API key
        [ValidateNotNullOrEmpty()]
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

        [Parameter(Mandatory)]
        [ValidateSet('Default', 'Get', 'Head', 'Post', 'Put', 'Delete', 'Trace', 'Options', 'Merge', 'Patch')]
        [String]
        $Method,

        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [Uri]
        $Uri,

        [ValidateNotNullOrEmpty()]
        [String]
        $PSTypeName,

        [Hashtable]
        $Body,

        # A comma-separated list of properties to get summary information on. Property names
        # can also be in the format of "property:count", where "count" is the number of facets
        # that will be returned for a property (i.e. "country:100" to get the top 100 countries
        # for a search query).
        [ValidateSet('author', 'platform', 'port', 'source', 'type')]
        [String[]]
        $Facets,

        # The page number to page through results 100 at a time. Overrides the
        # "offset" and "limit" parameters if they were provided (default: 1)
        [Int]
        $Page,

        # The positon from which the search results should be returned (default: 0)
        [Int]
        $Offset,

        # The number of results to be returned default(100)
        [Int]
        $Limit
    )
    begin {
        if (!(Test-Path Variable:Global:ShodanApiKey ) -and !($PSBoundParameters.ContainsKey('ApiKey'))) {
            throw 'No Shodan API Key has been specified or set.'
            return
        }
        elseif (!($PSBoundParameters.ContainsKey('ApiKey'))) {
            $ApiKey = $Global:ShodanApiKey
        }
        if ($PSBoundParameters.ContainsKey('Body') -and ($Body.Count -gt 0)) {
            $LocalBody = $Body
            $LocalBody['key'] = $ApiKey
        }
        else {
            $LocalBody = @{ 'key' = $ApiKey }
        }
        $PassthroughDefinitions = @{
            'Facets' = { $LocalBody['facets'] = ($Facets -join ',') }
            'Page'   = { $LocalBody['page']   = $Page }
            'Offset' = { $LocalBody['offset'] = $Offset }
            'Limit'  = { $LocalBody['limit']  = $Limit }
        }
        foreach ($PassthroughDefinition in $PassthroughDefinitions.GetEnumerator()) {
            if ($PSBoundParameters.ContainsKey($PassthroughDefinition.Key)) {
                Invoke-Command -ScriptBlock $PassthroughDefinition.Value
            }
        }
        $InvokeParameters =  @{
            'Body'    = $LocalBody
            'Method'  = $Method
            'Uri'     = $Uri
        }
        $PassthroughParameters = @(
            'CertificateThumbprint'
            'Proxy'
            'ProxyCredential'
            'ProxyUseDefaultCredentials'
        )
        foreach ($PassthroughParameter in $PassthroughParameters) {
            if ($PSBoundParameters.ContainsKey($PassthroughParameter)) {
                $InvokeParameters[$PassthroughParameter] = $PSBoundParameters[$PassthroughParameter]
            }
        }
    }
    process {
        $ReturnedObject = Invoke-RestMethod @InvokeParameters
        if ($ReturnedObject -and $PSBoundParameters.ContainsKey('PSTypeName')) {
            $ReturnedObject.PSTypeNames.Insert(0, $PSTypeName)
        }
        $ReturnedObject
    }
    end {
    }
}
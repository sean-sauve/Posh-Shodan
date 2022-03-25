function Add-ShodanPassthroughParameter {
    <#
        .SYNOPSIS
        Adds standard Shodan keys and values from one hashtable to another and returns the result.
        .DESCRIPTION
        Adds standard Shodan keys and values from one hashtable to another and returns the result.
        Looks for KeyName in FromHashtable and adds to ToHashtable
        .PARAMETER FromHashtable
        The hashtable that has the keys to add to ToHashtable.
        .PARAMETER ToHashtable
        The hashtable that the keys will be added to.
        .PARAMETER KeyName
        String array of the keys to look for.  Default is the standard Shodan passthrough parameters:
            ApiKey
            CertificateThumbprint
            Proxy
            ProxyCredential
            ProxyUseDefaultCredentials
            Facets
            Page
            Offet
            Limit
        .EXAMPLE
        Add-ShodanPassthroughParameter -FromHashtable $fromHash -ToHashtable $toHash -KeyName @('MyKey1', 'MyKey2')
        .INPUTS
        Two hashtables and a string array.
        .OUTPUTS
        Hashtable.
        .NOTES
        Original Author: Sean Sauve
    #>
    [CmdletBinding()]
    [OutputType([hashtable])]
    param (
        [Parameter(Mandatory)]
        [hashtable]$FromHashtable,

        [hashtable]$ToHashtable,

        [string[]]$KeyName = @(
            'ApiKey'
            'CertificateThumbprint'
            'Proxy'
            'ProxyCredential'
            'ProxyUseDefaultCredentials'
            'Facets'
            'Page'
            'Offet'
            'Limit'
        )
    )
    Add-Hash -FromHashtable $FromHashtable -ToHashtable $ToHashtable -KeyName $KeyName -Verbose:$false
}

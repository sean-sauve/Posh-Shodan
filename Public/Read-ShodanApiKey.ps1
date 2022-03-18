#  .ExternalHelp Posh-Shodan.Help.xml
function Read-ShodanAPIKey
{
    [CmdletBinding()]

    Param
    (

        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [securestring]$MasterPassword
    )

    Begin
    {
        # Test if configuration file exists.
        if (!(Test-Path -Path "$($env:AppData)\Posh-Shodan\api.key"))
        {
            throw 'Configuration has not been set, Set-ShodanAPIKey to configure the API Keys.'
        }
    }
    Process
    {
        Write-Verbose -Message "Reading key from $($env:AppData)\Posh-Shodan\api.key."
        $ConfigFileContent = Get-Content -Path "$($env:AppData)\Posh-Shodan\api.key"
        Write-Debug -Message "Secure string is $($ConfigFileContent)"

        $SaltBytes = Get-Content -Encoding Byte -Path "$($env:AppData)\Posh-Shodan\salt.rnd" 
        $Credentials = New-Object System.Management.Automation.PSCredential -ArgumentList 'user', $MasterPassword

        # Derive Key, IV and Salt from Key
        $Rfc2898Deriver = New-Object System.Security.Cryptography.Rfc2898DeriveBytes -ArgumentList $Credentials.GetNetworkCredential().Password, $SaltBytes
        $KeyBytes  = $Rfc2898Deriver.GetBytes(32)

        $SecString = ConvertTo-SecureString -Key $KeyBytes $ConfigFileContent

        # Decrypt the secure string.
        $SecureStringToBSTR = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecString)
        $APIKey = [Runtime.InteropServices.Marshal]::PtrToStringAuto($SecureStringToBSTR)

        # Set session variable with the key.
        Write-Verbose -Message "Setting key $($APIKey) to variable for use by other commands."
        $Global:ShodanAPIKey = $APIKey
        Write-Verbose -Message 'Key has been set.'
    }
    End
    {
    }
}

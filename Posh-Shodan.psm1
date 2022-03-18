$PS1Files = Get-ChildItem -Name "$PSScriptRoot\*.ps1"
foreach ($PS1File in $PS1Files) {
	. $PSScriptRoot\$($PS1File.split(".")[0])
}
$PrivatePS1Files = Get-ChildItem -Name "$PSScriptRoot\Private\*.ps1"
foreach ($PS1File in $PrivatePS1Files) {
    . $PSScriptRoot\Private\$($PS1File.split(".")[0])
}
$ExportedFunctions = @(
	'Get-ShodanApiInfo'
	'Get-ShodanDnsResolve'
	'Get-ShodanDnsReverse'
	'Get-ShodanHostService'
	'Get-ShodanMyIp'
	'Get-ShodanService'
	'Invoke-ShodanApi'
	'Measure-ShodanExploit'
	'Measure-ShodanHost'
	'Read-ShodanApiKey'
	'Search-ShodanExploit'
	'Search-ShodanHost'
	'Set-ShodanApiKey'
)
Export-ModuleMember -Function $ExportedFunctions -Alias * -Cmdlet *

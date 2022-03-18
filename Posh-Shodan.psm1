$PublicFolders = @(
	'Public'
)
$PrivateFolders = @(
	'Private'
)
$PublicFunctions = foreach ($Folder in $PublicFolders) {
	$Files = @()
	$Files = Get-ChildItem -Name "$PSScriptRoot\$Folder\*.ps1"
	foreach ($File in $Files) {
		. "$PSScriptRoot\$Folder\$($File.Split('.')[0])"
		$File.Split('.')[0]
	}
}
foreach ($Folder in $PrivateFolders) {
	$Files = @()
	$Files = Get-ChildItem -Name "$PSScriptRoot\$Folder\*.ps1"
	foreach ($File in $Files) {
		. "$PSScriptRoot\$Folder\$($File.Split('.')[0])"
	}
}
Export-ModuleMember -Function $PublicFunctions -Alias * -Cmdlet *

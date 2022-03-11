$PS1Files = Get-ChildItem -Name "$PSScriptRoot\*.ps1"
ForEach ($PS1File in $PS1Files) {
	. $PSScriptRoot\$($PS1File.split(".")[0])
}

Export-ModuleMember -Function * -Alias * -Cmdlet *
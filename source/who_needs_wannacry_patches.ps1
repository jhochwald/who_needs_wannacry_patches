#requires -Version 2.0 -Modules ActiveDirectory

<#
		.SYNOPSIS
		Check if all systems have the WannaCry related Hotfixes installed
	
		.DESCRIPTION
		Check if all systems have the WannaCry related Hotfixes installed.
		Checks given Computers, or all server systems found in the Active Directory (default)
	
		.PARAMETER ComputerList
		Name, or list of computers to check
	
		.EXAMPLE
		# Check if WindowsServer1 have all WannaCry related hotfixes installed
		PS C:\> .\who_needs_wannacry_patches.ps1 -ComputerList 'WindowsServer1'

		.EXAMPLE
		# Check if WindowsServer1 and WinDC01 have all WannaCry related hotfixes installed
		# In this example the Server WinDC01 is unreachable.
		PS C:\> .\who_needs_wannacry_patches.ps1 -ComputerList 'WindowsServer1','WinDC01'

		WARNING: WinDC01 is offline or unreachable.

		.EXAMPLE
		# Check all systems found in the Active Directory have all WannaCry related hotfixes installed
		# In this example the System ZRHW10VM01 is missing some of the WannaCry hotfixes
		PS C:\> .\who_needs_wannacry_patches.ps1

		WARNING: ZRHW10VM01 is missing WannaCry hotfix
	
		.NOTES
		Advice:
		You need to review and tweak the Filter in Line 76
		Please note, that the WannaCry problem doesn't apply to Windows 10 (Just in case you change the filter to clients)

		History:
		2017-05-15 - Add the following KB4015549, KB4015552, KB4015553, and KB4019264
		2017-05-15 - Another tweak to the Filter (Line 76) to avoid Windows 10 but covers all other Windows OSes
		2017-05-15 - The newer version contains a fixed KB List / Removed the Signature
		2017-05-12 - Inital Version WannaCry

		License:
		Public Domain

		General:
		The code is provided 'as is,' with all possible faults, defects or errors, and without warranty of any kind.

		.LINKS
		https://technet.microsoft.com/en-us/library/security/ms17-010.aspx
		https://hochwald.net/check-wannacry-related-hotfixes-installed/
#>
param
(
	[Parameter(ValueFromPipeline = $true,
			ValueFromPipelineByPropertyName = $true,
	Position = 1)]
	[string[]]
	$ComputerList
)

begin {
	# List of fixes we search for, in this case all fixes relates to WannaCry
	# Source List: https://technet.microsoft.com/en-us/library/security/ms17-010.aspx and feedback
	$hotfixes = 'KB4012212', 'KB4012213', 'KB4012214', 'KB4012215', 'KB4012216', 'KB4012217', 'KB4012598', 'KB4012606', 'KB4013198', 'KB4013429', 'KB4015217', 'KB4015438', 'KB4015549', 'KB4015550', 'KB4015551', 'KB4015552', 'KB4015553', 'KB4016635', 'KB4019215', 'KB4019216', 'KB4019264', 'KB4019472'
}

process {

	if (-not ($ComputerList))
	{
		try 
		{
			# Filter for all Windows Systems, ignore our Mac's an Windows 10
			$ComputerList = Get-ADComputer -Filter {
				(OperatingSystem  -Like 'Windows*') -and (OperatingSystem -notlike '*Windows 10*')
			} | Select-Object -ExpandProperty 'Name'
		}
		catch 
		{
			Write-Error -Message 'Unable to get the List of computers from the Active Directory' -ErrorAction Stop
		}
	}

	# Loop over the List of computers
	foreach($computer in $ComputerList) 
	{
		if(-not(Test-Connection -ComputerName $computer -Count 1 -Quiet)) 
		{
			Write-Verbose -Message "$computer is possibly offline or unreachable (Try anyway)."
		}

		try 
		{
			$hotfix = Get-HotFix -ComputerName $computer | 
			Where-Object -FilterScript {
				$hotfixes -contains $_.HotfixID
			} | 
			Select-Object -ExpandProperty 'HotFixID'

			if($hotfix) 
			{
				Write-Verbose -Message "$computer has hotfix $hotfix installed"
			}
			else 
			{
				Write-Warning -Message "$computer is missing WannaCry hotfix"
				continue
			}
		}
		catch 
		{
			Write-Warning -Message "Unable to get Hostfix Info from $computer"
			continue
		}
	}
}

<#
		I removed the signature to make it easier for others to adopt it (e.g. Tweak or changes)
		If you need a signed version, just drop me a line and I can sign one for you.

		NOTE: If you change something, upload it as Gist to GitHub and send me the link.

		And yes, I'll sign the script for free! Why not? (Before you ask!)
#>
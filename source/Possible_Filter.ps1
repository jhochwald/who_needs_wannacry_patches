# Here we filter all Windows based Systems, that will avoid the Linux and Mac Systems
$ComputerList = Get-ADComputer -Filter {
	OperatingSystem  -Like 'Windows*'
} -Property OperatingSystem

foreach($computer in $ComputerList) 
{
	If ($_.OperatingSystem -match 'Windows 10') 
	{
		# Windows Client 10
	}
	elseif ($_.OperatingSystem -match 'Windows 8.1') 
	{
		# Windows Client 8.1
	}
	elseif ($_.OperatingSystem -match 'Windows Server 2016') 
	{
		# Windows Server 2016
	}
	elseif ($_.OperatingSystem -match 'Windows Server 2012 R2') 
	{

	}
	elseif ($_.OperatingSystem -match 'Windows Server 2012') 
	{
		# Windows Server 2012 (Get rid of this soon)
	}
	elseif ($_.OperatingSystem -match 'Windows 8') 
	{
		# Windows Client 8.0 (Get rid of this soon)
	}
	elseif ($_.OperatingSystem -like 'Windows Server 2008 R2*') 
	{
		# Windows Server 2008  (Get rid of this soon)
	}
	elseif ($_.OperatingSystem -like 'Windows Server 2008*') 
	{
		# Windows Server 2008  (Get rid of this soon)
	}
	elseif ($_.OperatingSystem -match 'Windows 7') 
	{
		# Windows Client 7
	}
	elseif ($_.OperatingSystem -match 'Windows Vista') 
	{
		# Windows Client VISTA (Get rid of this soon)
	}
	elseif ($_.OperatingSystem -match 'Windows XP') 
	{
		# Windows Client XP  (You are doomed)
	}
	elseif ($_.OperatingSystem -like 'Windows Server 2003*') 
	{
		# Windows Server 2003 (You are doomed)
	}
	else
	{
		# Unknown Windows. Could be Windows 2000 :(
	}
}

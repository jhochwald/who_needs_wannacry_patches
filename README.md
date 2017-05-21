# Search for WannaCry Vulnerabilities

The tool is scanning all Windows Systems in your Active Directory for the following:

* Are the EternalBlue (WannyCry) related Hotfixes installed
* Is SMBv1 still installed
* Is SMBv1 still activated

The tool generates a CSV File with the information above. You can then use Excel (or any other tool that can do this) to filter for everything you would like to know.

Tha basic ideas is based my [Gist](https://gist.github.com/jhochwald/666a0b51f2d13d62e63c9e4200168793) that I published while the first WannyCry wave hits.

I extended the Tool based on requests and feedback.

### Table Of Contents
<!-- MarkdownTOC depth=3 autolink=true autoanchor=true bracket=round -->

- [Main Screen](#main-screen)
- [Run](#run)
- [Report Format](#report-format)
	- [Naming Convention](#naming-convention)
	- [Content](#content)
		- [ComputerName](#computername)
		- [Operating System](#operating-system)
		- [Version](#version)
		- [LastReboot](#lastreboot)
		- [WannaCryHotFix](#wannacryhotfix)
		- [SMBv1Installed](#smbv1installed)
		- [SMBv1Enabled](#smbv1enabled)
- [Installation \(Optional\)](#installation-optional)
	- [Check](#check)
- [General](#general)
	- [Support](#support)
	- [Hotfixes](#hotfixes)
		- [Missing Link](#missing-link)
	- [Changes](#changes)
	- [Roadmap](#roadmap)
	- [Requirements](#requirements)
	- [Source Code](#source-code)
	- [Signed](#signed)
	- [Why this tool](#why-this-tool)
	- [Why Free](#why-free)
	- [Warranty](#warranty)
	- [Copyright](#copyright)
	- [License](#license)

<!-- /MarkdownTOC -->


<a name="main-screen"></a>
## Main Screen

<img src="docs/Start_Screen.png?raw=true" />

There is nothing to configure. The Report is a CSV File that is created where the executable is.

<a name="run"></a>
## Run

<img src="docs/Scan_Run.png?raw=true" />

This might take a while. The Time depends upon the number of computers found in the Active Directory and your Network Performance!

**You need to run the Tool as Administrator (Elevated)!**

<a name="report-format"></a>
## Report Format

Since Version 2, the tools generates a CSV Reporting. It also contains the SMBv1 related information. So it contains the info of my other scripts as well.

<img src="docs/Report_Sample.png?raw=true" />

<a name="naming-convention"></a>
### Naming Convention

The Name of the Report is **HotfixReport-** and there is the following Date String appended to each run `yyy-mm-dd-hhmm`. The extension is `.csv`.

Example:

`HotfixReport-2017-16-16-0316.txt`

That Sameple is generated on May, 16th 2017 at 3:16.

<a name="content"></a>
### Content

The following fields are reported

<a name="computername"></a>
#### ComputerName

Name of the target system.

Example:

`TESTVM01`

If the system reports another name (via the CIM session) as the one returned from the Active Directoy, the Tool use this.

<a name="operating-system"></a>
#### Operating System

The Operating System reported by CIM

Exapmles:

* `Microsoft Windows 10 Pro`
* `Microsoft Windows Server 2016 Standard`

Search the Microsoft Support or TechNet pages for all possible returns.

<a name="version"></a>
#### Version

The Operating System Version reported by CIM

Exapmles:

* `10.0.14393`
* `10.0.15063`

Search the Microsoft Support or TechNet pages for all possible returns.

<a name="lastreboot"></a>
#### LastReboot

The TimeStamp of the last Reboot (Uptime).
I found it usefull to have that info about the uptime of all systems. Might be useless.

Exapmles:

* `10.05.2017 15:47:14`
* `10.05.2017 16:07:40`

The TimeStamp uses the locales of your system!

<a name="wannacryhotfix"></a>
#### WannaCryHotFix

All EternalBlue (WannaCry) related and installed hotfixes.

As far as I understood Microsoft publications, all Versions later then 10.0.14393 are not effeted by the EternalBlue vulnerabilities, so I implemented a `Not Applicable` for them.

Examples:

* `Not Applicable` - For Windows Versions greater then 10.0.14393)
* `Unknown` - The tool was unable to get the info. You should check all of these ASAP!
* `KB4012212` - Just this EternalBlue (WannyCry) related fix is installed
* `KB4012212, KB4012213` - These two EternalBlue (WannyCry) related fixes are installed

<a name="smbv1installed"></a>
#### SMBv1Installed

Is the SMBv1 feature installed on the system? This is a Bool.

Examples:

* `True`
* `False`
* `Unknown` - The tool was unable to get the info. You should check all of these ASAP!

<a name="smbv1enabled"></a>
#### SMBv1Enabled

Is the SMBv1 feature activated on the system? This is a Bool.

Examples:

* `True`
* `False`
* `Unknown` - The tool was unable to get the info. You should check all of these ASAP!

<a name="installation-optional"></a>
## Installation (Optional)

I created a very simple (now 64Bit) MSI installer! No fancy options, nothing!

The Installer will deploy the Executable to the following Path by default:
`C:\Program Files\Enabling Technology\Search for WannaCry Vulnerabilities`

==Please note, that the location has changes since the last version.==

You do not need to install the Tool! If you copy the Executable and start it, this is just fine!
The Installer is more for convenience only. I know that some prefer to have a working installer for every tool.

<a name="check"></a>
### Check

<img src="docs/Installed_info.png?raw=true" />

<a name="general"></a>
## General

<a name="support"></a>
### Support

There is no Support! You can create an [Issue](https://github.com/jhochwald/who_needs_wannacry_patches/issues/new) if something is wrong.

<a name="hotfixes"></a>
### Hotfixes

The tool looks for the following Patches/Hotfixes:

* **KB4012212**
* **KB4012213**
* **KB4012214**
* **KB4012215**
* **KB4012216**
* **KB4012217**
* **KB4012598**
* **KB4012606**
* **KB4013198**
* **KB4013429**
* **KB4015217**
* **KB4015438**
* **KB4015549**
* **KB4015550**
* **KB4015551**
* **KB4015552**
* **KB4015553**
* **KB4016635**
* **KB4019215**
* **KB4019216**
* **KB4019264**
* **KB4019472**

A few more then required! But this is based on the fact, that Microsoft push a lot of Patches and Rollups. These could contain the needed paches, so I decided to include them as well.

<a name="missing-link"></a>
#### Missing Link

Some Operating Systems need more then one Patch/Hotfixes!

**With Version 2, the tool should be able to report them all. And you might then use Excel (or any other tool that can do the job) to filter whatever you want to know.**

As an example Server 2012 R2 needs the following:

* KB4012213
* KB4012216

##### Overview of the Hotfixes

Here is the List of Hotfixes that applies to the known EternalBlue (WannyCry) issue, for each Windows Version.

**Windows Vista**

* KB4012598

**Server 2008**

* KB4012598

**Server 2008 R2**

* KB4012212
* KB4012215

**Server 2012**

* KB4012214
* KB4012217

**Server 2012 R2**

* KB4012213
* KB4012216

**Windows 7**

* KB4012212
* KB4012215

**Windows 8.1**

* KB4012213
* KB4012216

**Windows RT 8.1**

* KB4012216

**Windows XP & Windows Server 2003/2003 R2**

* [https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/](https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/)

<a name="changes"></a>
### Changes

Here are the Changes from Version 1.0 to 2.0

* Changed the Output from plain ASC Text to CSV. That makes it easier to handle a report in a tool like Excel
* Dropped the `Get-HotFix` usage and use CIM instead
* Use some CIM calls to gather the needed information (Based on the [Enabling Technology](http://www.enatec.io) Framework)
* ~~Export to Excel to support native Excel Files instead of CSV~~ Had some issues with that.
* Gather more infos (e.g. the SMBv1 related infos)
* Get all related Hotfixes
* UI improved
* Elevation (Admin) check
* Scan now shows a bit more info while it runs
* Installer is now 64Bit

<a name="roadmap"></a>
### Roadmap

There is no plan to develop any further features or even fixes.
If someone find something bad or extends the functionality, I will publish newer versions.

<a name="requirements"></a>
### Requirements

There are a few requirements!
* The Tool must be elevated (**Run as Administrator is the default**)
* The RSAT Tools must be installed. Install it via Server Manager (Server) or Download (Client). Just Google for "*Windows RSAT*"
* The Computer that should run the scan needs to be Domain joined
* The permissions needs to fit!
* Remote PowerShell must be enabled: `$null = (Enable-PSRemoting -Force)` (*Execute this on the REMOTE systems*)
* The remote system should allow Remote Management (Check the ‘*Windows Remote Management*’ Rule)
* PowerShell 4.0, or newer needs to be installed
* Windows 7, or newer are required. Or Windows Server 2008R2, or newer.

You should have Domain Admin permission! And the remote systems (servers and clients) must allow remote connection and remote management.

I tested the Script ([Gist](https://gist.github.com/jhochwald/666a0b51f2d13d62e63c9e4200168793)) abd this Tool only on Windows 10 based Clients and Windows Server 2016 based Servers. I never tested it on any other OS! I should run :-)

<a name="source-code"></a>
### Source Code

**I decided not to publish the code!**

Some stuff is based on the commercial framework off [Enabling Technology](http://www.enatec.io) implementation. And Yep, I'm allowed to do that :)

But again: Most of the logic is based on the [Gist](https://gist.github.com/jhochwald/666a0b51f2d13d62e63c9e4200168793) I published.

<a name="signed"></a>
### Signed

The Executable and the Installer are signed with a valid certificate.
So there shouldn't be any problems with virus scanners or the execution/installation.

<a name="why-this-tool"></a>
### Why this tool

Because the EternalBlue (Related to WannCryt aka WannaCry) problem isn't solved and there are still unpatched systems.
And some might just want to have a report to see that there network is secure. And as a benefit: A SMBv1 related reporting is also included.

And some didn't (why ever) like Powershell!

<a name="why-free"></a>
### Why Free

Why not?

<a name="warranty"></a>
### Warranty

The Tool, the installer, and the code is provided 'as is,' with all possible faults, defects or errors, and without warranty of any kind.

<a name="copyright"></a>
### Copyright

(c) 2017 by Joerg Hochwald - [hochwald.net](http://hochwald.net)

<a name="license"></a>
### License

This tool, like the script, is general public domain. Even if I decided to keep the source of the tool closed. The source for most parts is availible.

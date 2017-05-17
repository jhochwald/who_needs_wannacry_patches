# Who needs WannaCry related patches

This is the executable version of my PowerShell Script, with a very basic UI.

In general, there is no big difference to the [Gist](https://gist.github.com/jhochwald/666a0b51f2d13d62e63c9e4200168793) I published a few days ago. This is a compiled PowerShell Script, and I added the Report File creation.

Even if all of your systems are patched, you should disable SMBv1 on all of them. Version 1 of the SMB implementation is 30 years old, slow and buggy! And there is no guarantee that with the hotfixes the existing security issues are all solved. There might be another attack, who knows! Trust me, SMBv1 is dangerous!!!

## Main Screen
![Main Screen](docs/Start_Screen.png)

There is nothing to configure. The Report is a plain ASC Text File that is created where the executable is.

## Run
![While it runs](docs/Scan_Run.png)

This might take a while. The Time depends upon the number of computers found in the Active Directory and your Network Performance!

## Report Format
![Report Sample](docs/Report_Sample.png)

Again: This is just a plain ASC File! First, I started with a CSV File, but based upon a request I changed that to a plain Text file.

### Naming Convention
The Name of the Report is:
**HotfixReport-** and there is the following Date String appended to each run: `yyy-mm-dd-hhmm`.
The extension is `.txt`.

#### Example
`HotfixReport-2017-16-16-0316.txt`
That File is generated on May, 16th 2017 at 3:16.

### Content
We talk about a very basic report here. I just implemented a limited number of text strings.

#### Good Case
`$computer has hotfix $hotfix installed`

#### Bad Case
`$computer is missing WannaCry hotfix`

#### Problem
`Unable to get Hostfix Info from $computer`

## Installation (Optional)
I created a very simple MSI installer! No fancy options, nothing!
The Installer will deploy the Executable to the following Path by default:
`C:\Program Files (x86)\Enabling Technology\Who needs WannaCry related patches`

You do not need to install the Tool! If you copy the Executable and start it, this is just fine! The Installer is more for convenience only. I know that some prefer to have a working installer for every tool.

### Check
![Check the Installation](docs/Installed_info.png)

## General

### Support
There is no Support! You can create an [Issue](https://github.com/jhochwald/who_needs_wannacry_patches/issues/new) if something is wrong.

### Hotfixes
The tool looks for the following Patches/Hotfixes.

* KB4012212
* KB4012213
* KB4012214
* KB4012215
* KB4012216
* KB4012217
* KB4012598
* KB4012606
* KB4013198
* KB4013429
* KB4015217
* KB4015438
* KB4015549
* KB4015550
* KB4015551
* KB4015552
* KB4015553
* KB4016635
* KB4019215
* KB4019216
* KB4019264
* KB4019472

A few more then required! But this is based on the fact, that Microsoft push a lot of Patches and Rollups. These could contain the needed paches, so I decided to include them as well.

#### Missing Link
Some Operating Systems need more then one Patch/Hotfixes!

As an example Server 2012 R2 needs the following:

* KB4012213
* KB4012216

The Script and the Tools (cause its based on the same source) will report the system as safe, even if there is just one of the two (2) needed installed.

That is a drawback! It's based on the fact, that the script is a quick hack, and I avoided any kind of logic. To make it better, the OS info from the Active Directory should be used. And the Hot fixes must be checked based on that.

This is something that others might want to develop, shouldn't be that hard. If someone accepts this challenge: Please feel free to implement it and send me a pull request. I would recompile and sign a new version :-)

#### Possible Solution
In the /source folder you will find a file called `Possible_Filter.ps1`.
This Filter is untested! It should work, but with the older Operating Systems... Just my guess how to find them. I don't have them, so this is really a best guess.
I found this in one off our reporting functions and adopted it by add the older versions. The input just works for Windows 10 (Client) and Windows Server 2012 R2, or newer (Server).

**The challenge**: There is a known list with Hotfixes for the Windows Versions. However, I have no idea what CU's contains these patches! And as soon as Microsoft publishes more of them the list gets more and more complex.

##### Overview of the Hotfixes
Here is the List of Hotfixes that applies to the known WannaCry issue, for each Windows Version.

**Windows Vista*** KB4012598**Server 2008*** KB4012598**Server 2008 R2*** KB4012212* KB4012215**Server 2012*** KB4012214* KB4012217**Server 2012 R2*** KB4012213* KB4012216**Windows 7*** KB4012212* KB4012215**Windows 8.1*** KB4012213* KB4012216**Windows RT 8.1*** KB4012216**Windows XP & Windows Server 2003/2003 R2*** [https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/](https://blogs.technet.microsoft.com/msrc/2017/05/12/customer-guidance-for-wannacrypt-attacks/)

### Roadmap
There is no plan to develop any further features or even fixes. 
If someone find something bad or extends the functionality, I will publish newer versions.

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

### Source Code
**I decided not to publish the code!**
But again: The logic is based on the [Gist](https://gist.github.com/jhochwald/666a0b51f2d13d62e63c9e4200168793) I published. The only missing part is the UI.

#### Customization?
This is not planned. If you honestly need any kind of customization, you will have to spend a few $!!! Contact me if this is sincerely needed. However, I think the general approach should fit in almost any cases!
And if not: Use the Script. You can customize whatever you like.

### Signed
The Executable and the Installer are signed with a valid certificate. So there shouldn't be any problems with virus scanners or the execution/installation.

### Why this tool
Because the WannCryt aka WannaCry problem isn't solved and there are still unpatched systems. 
And some didn't (why ever) like Powershell!

### Why Free
Why not? Sometimes it feels great if you can help others. And it's not all about the Benjamin's all the time :-)
And it took me just about an hour to put it all together. Most time was spent with this document and test everything.

#### Donations
If you want to donate something: Donate something to a good charity organization. 

On the other hand, buy me a drink if we ever meet :-)

And Star the Script and/or this repository!

### Warranty
The code is provided 'as is,' with all possible faults, defects or errors, and without warranty of any kind.

### Copyright
(c) 2017 by Joerg Hochwald - [hochwald.net](http://hochwald.net)

### License
This tool, like the script, is general public domain. Even if I decided to keep the source closed. 

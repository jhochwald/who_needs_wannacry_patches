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
# SIG # Begin signature block
# MIIYpQYJKoZIhvcNAQcCoIIYljCCGJICAQExCzAJBgUrDgMCGgUAMGkGCisGAQQB
# gjcCAQSgWzBZMDQGCisGAQQBgjcCAR4wJgIDAQAABBAfzDtgWUsITrck0sYpfvNR
# AgEAAgEAAgEAAgEAAgEAMCEwCQYFKw4DAhoFAAQU6s0+65grQK2+a/S9JdJWh1xM
# mUKgghPNMIID7jCCA1egAwIBAgIQfpPr+3zGTlnqS5p31Ab8OzANBgkqhkiG9w0B
# AQUFADCBizELMAkGA1UEBhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTEUMBIG
# A1UEBxMLRHVyYmFudmlsbGUxDzANBgNVBAoTBlRoYXd0ZTEdMBsGA1UECxMUVGhh
# d3RlIENlcnRpZmljYXRpb24xHzAdBgNVBAMTFlRoYXd0ZSBUaW1lc3RhbXBpbmcg
# Q0EwHhcNMTIxMjIxMDAwMDAwWhcNMjAxMjMwMjM1OTU5WjBeMQswCQYDVQQGEwJV
# UzEdMBsGA1UEChMUU3ltYW50ZWMgQ29ycG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFu
# dGVjIFRpbWUgU3RhbXBpbmcgU2VydmljZXMgQ0EgLSBHMjCCASIwDQYJKoZIhvcN
# AQEBBQADggEPADCCAQoCggEBALGss0lUS5ccEgrYJXmRIlcqb9y4JsRDc2vCvy5Q
# WvsUwnaOQwElQ7Sh4kX06Ld7w3TMIte0lAAC903tv7S3RCRrzV9FO9FEzkMScxeC
# i2m0K8uZHqxyGyZNcR+xMd37UWECU6aq9UksBXhFpS+JzueZ5/6M4lc/PcaS3Er4
# ezPkeQr78HWIQZz/xQNRmarXbJ+TaYdlKYOFwmAUxMjJOxTawIHwHw103pIiq8r3
# +3R8J+b3Sht/p8OeLa6K6qbmqicWfWH3mHERvOJQoUvlXfrlDqcsn6plINPYlujI
# fKVOSET/GeJEB5IL12iEgF1qeGRFzWBGflTBE3zFefHJwXECAwEAAaOB+jCB9zAd
# BgNVHQ4EFgQUX5r1blzMzHSa1N197z/b7EyALt0wMgYIKwYBBQUHAQEEJjAkMCIG
# CCsGAQUFBzABhhZodHRwOi8vb2NzcC50aGF3dGUuY29tMBIGA1UdEwEB/wQIMAYB
# Af8CAQAwPwYDVR0fBDgwNjA0oDKgMIYuaHR0cDovL2NybC50aGF3dGUuY29tL1Ro
# YXd0ZVRpbWVzdGFtcGluZ0NBLmNybDATBgNVHSUEDDAKBggrBgEFBQcDCDAOBgNV
# HQ8BAf8EBAMCAQYwKAYDVR0RBCEwH6QdMBsxGTAXBgNVBAMTEFRpbWVTdGFtcC0y
# MDQ4LTEwDQYJKoZIhvcNAQEFBQADgYEAAwmbj3nvf1kwqu9otfrjCR27T4IGXTdf
# plKfFo3qHJIJRG71betYfDDo+WmNI3MLEm9Hqa45EfgqsZuwGsOO61mWAK3ODE2y
# 0DGmCFwqevzieh1XTKhlGOl5QGIllm7HxzdqgyEIjkHq3dlXPx13SYcqFgZepjhq
# IhKjURmDfrYwggSjMIIDi6ADAgECAhAOz/Q4yP6/NW4E2GqYGxpQMA0GCSqGSIb3
# DQEBBQUAMF4xCzAJBgNVBAYTAlVTMR0wGwYDVQQKExRTeW1hbnRlYyBDb3Jwb3Jh
# dGlvbjEwMC4GA1UEAxMnU3ltYW50ZWMgVGltZSBTdGFtcGluZyBTZXJ2aWNlcyBD
# QSAtIEcyMB4XDTEyMTAxODAwMDAwMFoXDTIwMTIyOTIzNTk1OVowYjELMAkGA1UE
# BhMCVVMxHTAbBgNVBAoTFFN5bWFudGVjIENvcnBvcmF0aW9uMTQwMgYDVQQDEytT
# eW1hbnRlYyBUaW1lIFN0YW1waW5nIFNlcnZpY2VzIFNpZ25lciAtIEc0MIIBIjAN
# BgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAomMLOUS4uyOnREm7Dv+h8GEKU5Ow
# mNutLA9KxW7/hjxTVQ8VzgQ/K/2plpbZvmF5C1vJTIZ25eBDSyKV7sIrQ8Gf2Gi0
# jkBP7oU4uRHFI/JkWPAVMm9OV6GuiKQC1yoezUvh3WPVF4kyW7BemVqonShQDhfu
# ltthO0VRHc8SVguSR/yrrvZmPUescHLnkudfzRC5xINklBm9JYDh6NIipdC6Anqh
# d5NbZcPuF3S8QYYq3AhMjJKMkS2ed0QfaNaodHfbDlsyi1aLM73ZY8hJnTrFxeoz
# C9Lxoxv0i77Zs1eLO94Ep3oisiSuLsdwxb5OgyYI+wu9qU+ZCOEQKHKqzQIDAQAB
# o4IBVzCCAVMwDAYDVR0TAQH/BAIwADAWBgNVHSUBAf8EDDAKBggrBgEFBQcDCDAO
# BgNVHQ8BAf8EBAMCB4AwcwYIKwYBBQUHAQEEZzBlMCoGCCsGAQUFBzABhh5odHRw
# Oi8vdHMtb2NzcC53cy5zeW1hbnRlYy5jb20wNwYIKwYBBQUHMAKGK2h0dHA6Ly90
# cy1haWEud3Muc3ltYW50ZWMuY29tL3Rzcy1jYS1nMi5jZXIwPAYDVR0fBDUwMzAx
# oC+gLYYraHR0cDovL3RzLWNybC53cy5zeW1hbnRlYy5jb20vdHNzLWNhLWcyLmNy
# bDAoBgNVHREEITAfpB0wGzEZMBcGA1UEAxMQVGltZVN0YW1wLTIwNDgtMjAdBgNV
# HQ4EFgQURsZpow5KFB7VTNpSYxc/Xja8DeYwHwYDVR0jBBgwFoAUX5r1blzMzHSa
# 1N197z/b7EyALt0wDQYJKoZIhvcNAQEFBQADggEBAHg7tJEqAEzwj2IwN3ijhCcH
# bxiy3iXcoNSUA6qGTiWfmkADHN3O43nLIWgG2rYytG2/9CwmYzPkSWRtDebDZw73
# BaQ1bHyJFsbpst+y6d0gxnEPzZV03LZc3r03H0N45ni1zSgEIKOq8UvEiCmRDoDR
# EfzdXHZuT14ORUZBbg2w6jiasTraCXEQ/Bx5tIB7rGn0/Zy2DBYr8X9bCT2bW+IW
# yhOBbQAuOA2oKY8s4bL0WqkBrxWcLC9JG9siu8P+eJRRw4axgohd8D20UaF5Mysu
# e7ncIAkTcetqGVvP6KUwVyyJST+5z3/Jvz4iaGNTmr1pdKzFHTx/kuDDvBzYBHUw
# ggVMMIIENKADAgECAhAW1PdTHZsYJ0/yJnM0UYBcMA0GCSqGSIb3DQEBCwUAMH0x
# CzAJBgNVBAYTAkdCMRswGQYDVQQIExJHcmVhdGVyIE1hbmNoZXN0ZXIxEDAOBgNV
# BAcTB1NhbGZvcmQxGjAYBgNVBAoTEUNPTU9ETyBDQSBMaW1pdGVkMSMwIQYDVQQD
# ExpDT01PRE8gUlNBIENvZGUgU2lnbmluZyBDQTAeFw0xNTA3MTcwMDAwMDBaFw0x
# ODA3MTYyMzU5NTlaMIGQMQswCQYDVQQGEwJERTEOMAwGA1UEEQwFMzU1NzYxDzAN
# BgNVBAgMBkhlc3NlbjEQMA4GA1UEBwwHTGltYnVyZzEYMBYGA1UECQwPQmFobmhv
# ZnNwbGF0eiAxMRkwFwYDVQQKDBBLcmVhdGl2U2lnbiBHbWJIMRkwFwYDVQQDDBBL
# cmVhdGl2U2lnbiBHbWJIMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
# ryMOYXRM7T2omd0n14YWqtrWV/Xg0OEzzAhPxwVxn8BfZfOsTrNv/yQTmwvj90yG
# 5M6n5Iy3S0j9I43oFjfbTy/82UMjt+jMCod+a8+Etfqn9O0OSZIfWwPwAjKtMf1v
# bvAM1fisL3XgprgQEjywa1nBk5CTBB2VXqAIGZp1qv7tiRWEBsgiRJrMT3LJFO59
# +J2a0dXj0Mc+v6qXiOI0n8rbtkVlvAzqQYGUMEFKAtQq+58xj5c9S6SnN0JoDRTP
# KAZR0N+DLSG1JKnwxH1GerhYwvS399PQhm+avEKuHs1eRBcAKTbG2eSrRtdQgLof
# RmiWd+Xh9qe9VjK8PzyogQIDAQABo4IBsjCCAa4wHwYDVR0jBBgwFoAUKZFg/4pN
# +uv5pmq4z/nmS71JzhIwHQYDVR0OBBYEFJ5Ubj/1S9WOa/xJPLh/uQYe5xKGMA4G
# A1UdDwEB/wQEAwIHgDAMBgNVHRMBAf8EAjAAMBMGA1UdJQQMMAoGCCsGAQUFBwMD
# MBEGCWCGSAGG+EIBAQQEAwIEEDBGBgNVHSAEPzA9MDsGDCsGAQQBsjEBAgEDAjAr
# MCkGCCsGAQUFBwIBFh1odHRwczovL3NlY3VyZS5jb21vZG8ubmV0L0NQUzBDBgNV
# HR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLmNvbW9kb2NhLmNvbS9DT01PRE9SU0FD
# b2RlU2lnbmluZ0NBLmNybDB0BggrBgEFBQcBAQRoMGYwPgYIKwYBBQUHMAKGMmh0
# dHA6Ly9jcnQuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNvZGVTaWduaW5nQ0EuY3J0
# MCQGCCsGAQUFBzABhhhodHRwOi8vb2NzcC5jb21vZG9jYS5jb20wIwYDVR0RBBww
# GoEYaG9jaHdhbGRAa3JlYXRpdnNpZ24ubmV0MA0GCSqGSIb3DQEBCwUAA4IBAQBJ
# JmTEqjcTIST+pbRkKzsIMMcpPHdRyoTGKCxpjQNGj19taCpbKci2yp3AWS5BgnHO
# SeqbYky/AgroG19ZzrhZmHLQG0jdLeHHNgfEONUMEsHL3WSP+Z10+N6frRb4vrqg
# 0ReIG4iw5wn17u0fpWf14URSO6rl6ygkzoVX4wgq/+M8VYynkHoS1fgsMcSliktF
# VCe7GhzfyaZ341+NwPb+j/zVu7ouYEV6AcBoYOlOEZ/weTc1XLQZylDe2uqYfp7c
# KmbxS3lSShI41l2RhbCvOSbMWAnKgzaudMxOHh+JzEFCkHsiS/hUSesdFF6KFnTP
# A34eRc7VcSd3eGb7TyMvMIIF4DCCA8igAwIBAgIQLnyHzA6TSlL+lP0ct800rzAN
# BgkqhkiG9w0BAQwFADCBhTELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIg
# TWFuY2hlc3RlcjEQMA4GA1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENB
# IExpbWl0ZWQxKzApBgNVBAMTIkNPTU9ETyBSU0EgQ2VydGlmaWNhdGlvbiBBdXRo
# b3JpdHkwHhcNMTMwNTA5MDAwMDAwWhcNMjgwNTA4MjM1OTU5WjB9MQswCQYDVQQG
# EwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAwDgYDVQQHEwdTYWxm
# b3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEGA1UEAxMaQ09NT0RP
# IFJTQSBDb2RlIFNpZ25pbmcgQ0EwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEK
# AoIBAQCmmJBjd5E0f4rR3elnMRHrzB79MR2zuWJXP5O8W+OfHiQyESdrvFGRp8+e
# niWzX4GoGA8dHiAwDvthe4YJs+P9omidHCydv3Lj5HWg5TUjjsmK7hoMZMfYQqF7
# tVIDSzqwjiNLS2PgIpQ3e9V5kAoUGFEs5v7BEvAcP2FhCoyi3PbDMKrNKBh1SMF5
# WgjNu4xVjPfUdpA6M0ZQc5hc9IVKaw+A3V7Wvf2pL8Al9fl4141fEMJEVTyQPDFG
# y3CuB6kK46/BAW+QGiPiXzjbxghdR7ODQfAuADcUuRKqeZJSzYcPe9hiKaR+ML0b
# tYxytEjy4+gh+V5MYnmLAgaff9ULAgMBAAGjggFRMIIBTTAfBgNVHSMEGDAWgBS7
# r34CPfqm8TyEjq3uOJjs2TIy1DAdBgNVHQ4EFgQUKZFg/4pN+uv5pmq4z/nmS71J
# zhIwDgYDVR0PAQH/BAQDAgGGMBIGA1UdEwEB/wQIMAYBAf8CAQAwEwYDVR0lBAww
# CgYIKwYBBQUHAwMwEQYDVR0gBAowCDAGBgRVHSAAMEwGA1UdHwRFMEMwQaA/oD2G
# O2h0dHA6Ly9jcmwuY29tb2RvY2EuY29tL0NPTU9ET1JTQUNlcnRpZmljYXRpb25B
# dXRob3JpdHkuY3JsMHEGCCsGAQUFBwEBBGUwYzA7BggrBgEFBQcwAoYvaHR0cDov
# L2NydC5jb21vZG9jYS5jb20vQ09NT0RPUlNBQWRkVHJ1c3RDQS5jcnQwJAYIKwYB
# BQUHMAGGGGh0dHA6Ly9vY3NwLmNvbW9kb2NhLmNvbTANBgkqhkiG9w0BAQwFAAOC
# AgEAAj8COcPu+Mo7id4MbU2x8U6ST6/COCwEzMVjEasJY6+rotcCP8xvGcM91hoI
# lP8l2KmIpysQGuCbsQciGlEcOtTh6Qm/5iR0rx57FjFuI+9UUS1SAuJ1CAVM8bdR
# 4VEAxof2bO4QRHZXavHfWGshqknUfDdOvf+2dVRAGDZXZxHNTwLk/vPa/HUX2+y3
# 92UJI0kfQ1eD6n4gd2HITfK7ZU2o94VFB696aSdlkClAi997OlE5jKgfcHmtbUIg
# os8MbAOMTM1zB5TnWo46BLqioXwfy2M6FafUFRunUkcyqfS/ZEfRqh9TTjIwc8Jv
# t3iCnVz/RrtrIh2IC/gbqjSm/Iz13X9ljIwxVzHQNuxHoc/Li6jvHBhYxQZ3ykub
# Ua9MCEp6j+KjUuKOjswm5LLY5TjCqO3GgZw1a6lYYUoKl7RLQrZVnb6Z53BtWfht
# Kgx/GWBfDJqIbDCsUgmQFhv/K53b0CDKieoofjKOGd97SDMe12X4rsn4gxSTdn1k
# 0I7OvjV9/3IxTZ+evR5sL6iPDAZQ+4wns3bJ9ObXwzTijIchhmH+v1V04SF3Awpo
# bLvkyanmz1kl63zsRQ55ZmjoIs2475iFTZYRPAmK0H+8KCgT+2rKVI2SXM3CZZgG
# ns5IW9S1N5NGQXwH3c/6Q++6Z2H/fUnguzB9XIDj5hY5S6cxggRCMIIEPgIBATCB
# kTB9MQswCQYDVQQGEwJHQjEbMBkGA1UECBMSR3JlYXRlciBNYW5jaGVzdGVyMRAw
# DgYDVQQHEwdTYWxmb3JkMRowGAYDVQQKExFDT01PRE8gQ0EgTGltaXRlZDEjMCEG
# A1UEAxMaQ09NT0RPIFJTQSBDb2RlIFNpZ25pbmcgQ0ECEBbU91MdmxgnT/ImczRR
# gFwwCQYFKw4DAhoFAKB4MBgGCisGAQQBgjcCAQwxCjAIoAKAAKECgAAwGQYJKoZI
# hvcNAQkDMQwGCisGAQQBgjcCAQQwHAYKKwYBBAGCNwIBCzEOMAwGCisGAQQBgjcC
# ARUwIwYJKoZIhvcNAQkEMRYEFCcBJbuEDdyJ6kDl5z7XjLUqt9IKMA0GCSqGSIb3
# DQEBAQUABIIBAJz2IpApkANysJgEQl4eFp7kGDagSiOWoIYUhUSb4Q6GI10HfoQs
# nSR0xCC8O7JQFtdV4Bh7bVAb5VqiUIvzBC7QoZiVqdseiwqDFM5lFOJ81wDKspnz
# 3bUKdJ+6IbVBgCh6UfY8VdKzbssyIu8d34PohDn3NAAujjpxAEfoU1Z6QIsXDtBV
# 65KXP76D8iw1coeQdQCCi9kQQavpBEdcQTcfnWqDJXtBewK6QvM6OURAEsw5DzF9
# J1SuMaqEs0Kzg6O34bKYIehrYhkx7U6Z47pC1HIX6AXM47DV9JNijqpTeZXQBVvc
# ap2F+3kSoqNukUbbyFX2dAbtvvRPv02syqShggILMIICBwYJKoZIhvcNAQkGMYIB
# +DCCAfQCAQEwcjBeMQswCQYDVQQGEwJVUzEdMBsGA1UEChMUU3ltYW50ZWMgQ29y
# cG9yYXRpb24xMDAuBgNVBAMTJ1N5bWFudGVjIFRpbWUgU3RhbXBpbmcgU2Vydmlj
# ZXMgQ0EgLSBHMgIQDs/0OMj+vzVuBNhqmBsaUDAJBgUrDgMCGgUAoF0wGAYJKoZI
# hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTcwNTE2MTQyNzIw
# WjAjBgkqhkiG9w0BCQQxFgQUuMb/twQ6mIDdO2s1v0WHNrY7+KowDQYJKoZIhvcN
# AQEBBQAEggEAAjHDd7uYorUcXtlmYLgsHtJPzzdh3zWFWfKs/2zgcs76HhR2XOXr
# Hie7fmFYWpXiSiNIaJPNnBTbehSMOQCBr8ND6IGsn7ENMpP9llyZNvUbic2bX5Kc
# KLwhTOjVYeJ6knK+1JT0p95w4OA6FxElsZCaNJb26zvxUbslfaiGqlyDSqRpczpn
# sfKct8En1RszttLbSTkpPy87altwd8IbsXOa7UMum9kvqGIRrm857nl6DiyXuD1h
# 1JsxYV7BboRAfCU+i+xPPX/NK8SgB8trUkEstrTNxQG1vwBPLRylrH8KWeVFsPPa
# 560xuBM/qREd+F2ejdHkL75UKaMepjyQNw==
# SIG # End signature block

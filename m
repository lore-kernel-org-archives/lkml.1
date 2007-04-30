Return-Path: <linux-kernel-owner+w=401wt.eu-S1423153AbXD3IEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423153AbXD3IEn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 04:04:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423148AbXD3IEn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 04:04:43 -0400
Received: from mx-out.strefa.interia.pl ([217.74.66.53]:46211 "EHLO
	mx-out.strefa.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423145AbXD3IEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 04:04:40 -0400
X-Greylist: delayed 1924 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Apr 2007 04:04:40 EDT
Message-ID: <46359B8F.3070809@akcja.pl>
Date: Mon, 30 Apr 2007 09:32:31 +0200
From: Maciej Rutecki <mrutecki@akcja.pl>
Reply-To: mrutecki@akcja.pl
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
Cc: Linux-kernel <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.21-rc7-mm2] BUG while suspend to ram
References: <463476A3.9050305@gmail.com>
In-Reply-To: <463476A3.9050305@gmail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms080005080401030000050802"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms080005080401030000050802
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Maciej Rutecki pisze:
> BUG: at kernel/kthread.c:166 kthread_bind()
>  [<c01465ac>] _cpu_down+0x16c/0x250
>  [<c0146890>] disable_nonboot_cpus+0x60/0xf0
>  [<c014cd67>] pm_suspend_disk+0x177/0x2c0
>  [<c014b645>] enter_state+0xb5/0x200
>  [<c014b84d>] state_store+0xbd/0xd0
>  [<c014b790>] state_store+0x0/0xd0
>  [<c01be189>] subsys_attr_store+0x29/0x40
>  [<c01be3a4>] sysfs_write_file+0xd4/0x160
>  [<c017b701>] vfs_write+0xc1/0x160
>  [<c01be2d0>] sysfs_write_file+0x0/0x160
>  [<c017be11>] sys_write+0x41/0x70
>  [<c0187355>] sys_dup2+0xd5/0x100
>  [<c01040f6>] sysenter_past_esp+0x5f/0x85
>  [<c0330000>] xfrm_policy_insert+0x210/0x400
>  =======================
> 
> dmesg:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/dmesg.txt.gz
> lsmod:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/lsmod.txt.gz
> ver_linux:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/ver_linux.txt.gz
> lspci:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/lspci.txt.gz
> config:
> http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/config-2.6.21-rc7-mm2.gz
> 

I use this script:

http://www.unixy.pl/maciek/download/kernel/2.6.21-rc7--mm2/suspend_to_disk.sh

-- 
Maciej Rutecki <mrutecki@akcja.pl>
http://www.maciek.unixy.pl

--------------ms080005080401030000050802
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJAzCC
AtwwggJFoAMCAQICEBLyWQ/dl9RSVDwQQ7RU42QwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyOTEzNDcyOFoX
DTA3MDgyOTEzNDcyOFowQzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEgMB4G
CSqGSIb3DQEJARYRbXJ1dGVja2lAYWtjamEucGwwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAw
ggEKAoIBAQDOjGXhBB1tZNUE+qezno0MzCYJxWcz/yGoBkafNL8wfwlPPbGhu47NdLCbemqm
FA1sZJ8oBZ3s29GTsPXhYIXWbPxFn8rbljCGKG96/iC1jila0UCr/EDCSK9PV303x/orT+aC
XwEg3KA5yfMU7ypGXDiQ9mcPnNu/3JIUUtVVToFKLLx4+whn4ZcU2WOt50njRKG+gfBD1/Eo
enzkCh4ypywezgo9XCt6W6Sd742ktAN+6q/YGFDe7hHIx/s/cVD44GU3ItfXUR1PH3JqOcCd
I9ifNn0u6UpXb86EpP/fEC0J52rU6gv6Hy3eNoEGT713e6sMsf2lfeGz/iQavCT5AgMBAAGj
LjAsMBwGA1UdEQQVMBOBEW1ydXRlY2tpQGFrY2phLnBsMAwGA1UdEwEB/wQCMAAwDQYJKoZI
hvcNAQEFBQADgYEAc/EVSnVPN/TBZlpdK47pHW9mK+h+30CaET+xKRJN2jvgHqg/mAtN8Fae
gQWRJ4cNPlqsLVNb515+9DucvpBVEUZExLc7VXo4xqkNbbuhMH8NsQatW7951mFRS9Mr5reD
/DejuvOmgkMKXe5OSRO03LmA0mHXhkJjtf4XNcGOzzQwggLcMIICRaADAgECAhAS8lkP3ZfU
UlQ8EEO0VONkMA0GCSqGSIb3DQEBBQUAMGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQTAeFw0wNjA4MjkxMzQ3MjhaFw0wNzA4MjkxMzQ3MjhaMEMxHzAd
BgNVBAMTFlRoYXd0ZSBGcmVlbWFpbCBNZW1iZXIxIDAeBgkqhkiG9w0BCQEWEW1ydXRlY2tp
QGFrY2phLnBsMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAzoxl4QQdbWTVBPqn
s56NDMwmCcVnM/8hqAZGnzS/MH8JTz2xobuOzXSwm3pqphQNbGSfKAWd7NvRk7D14WCF1mz8
RZ/K25Ywhihvev4gtY4pWtFAq/xAwkivT1d9N8f6K0/mgl8BINygOcnzFO8qRlw4kPZnD5zb
v9ySFFLVVU6BSiy8ePsIZ+GXFNljredJ40ShvoHwQ9fxKHp85AoeMqcsHs4KPVwrelukne+N
pLQDfuqv2BhQ3u4RyMf7P3FQ+OBlNyLX11EdTx9yajnAnSPYnzZ9LulKV2/OhKT/3xAtCedq
1OoL+h8t3jaBBk+9d3urDLH9pX3hs/4kGrwk+QIDAQABoy4wLDAcBgNVHREEFTATgRFtcnV0
ZWNraUBha2NqYS5wbDAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAHPxFUp1Tzf0
wWZaXSuO6R1vZivoft9AmhE/sSkSTdo74B6oP5gLTfBWnoEFkSeHDT5arC1TW+defvQ7nL6Q
VRFGRMS3O1V6OMapDW27oTB/DbEGrVu/edZhUUvTK+a3g/w3o7rzpoJDCl3uTkkTtNy5gNJh
14ZCY7X+FzXBjs80MIIDPzCCAqigAwIBAgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UE
BhMCWkExFTATBgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYD
VQQKExFUaGF3dGUgQ29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNl
cyBEaXZpc2lvbjEkMCIGA1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJ
KoZIhvcNAQkBFhxwZXJzb25hbC1mcmVlbWFpbEB0aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAw
MFoXDTEzMDcxNjIzNTk1OVowYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25z
dWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJ
c3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1
BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAKMNcCY1osiRVwjt3J8CuFWqo/cVbLrzwL
B+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7n2XRxSpUhQ9IBH+nttE8YQRAHmQZ
cmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAwQwYDVR0fBDwwOjA4oDagNIYy
aHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJlZW1haWxDQS5jcmwwCwYD
VR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRlTGFiZWwyLTEzODAN
BgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9MIbj4Nh+qLZ82
L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowgT2Vfldr3
94fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCA2QwggNgAgEBMHYwYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAS8lkP3ZfUUlQ8
EEO0VONkMAkGBSsOAwIaBQCgggHDMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZI
hvcNAQkFMQ8XDTA3MDQzMDA3MzIzMVowIwYJKoZIhvcNAQkEMRYEFN7GkSj/qscZoY1z/Tle
ewLwlXUVMFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0G
CCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGFBgkrBgEEAYI3EAQxeDB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQEvJZD92X
1FJUPBBDtFTjZDCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29u
YWwgRnJlZW1haWwgSXNzdWluZyBDQQIQEvJZD92X1FJUPBBDtFTjZDANBgkqhkiG9w0BAQEF
AASCAQAwVx61usOwe+tpZ/CatoS+lzgSnjUhl2SWir9SBmXsv1pQGpQxAEfA91PsBOoJ2B4t
HIRn6JOw6tRgaEcI7nrcf2gzAIcE8hnS13Oy3y94Dneubc/G85tPymBar23H0vDaDMW29bB9
C+ks3YnVI7fypkoGnVVNTS7pHg3iNSB3SUOxClXLxz7J6GRCO6SMUVyFxLpJdmqzyVJ2YFRT
tkpq6y34cMKijl2ymoiVSGlJH6DXx1g56/nry9Fw8dImuBj+yNZW5d1INZKO29SmK6GSMwmX
HXBdtT7r0cP6FtXojldXLeCk/W/t1VDmRyid8W8mX6G5TMFNcZf391MpxVmoAAAAAAAA
--------------ms080005080401030000050802--

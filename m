Return-Path: <linux-kernel-owner+w=401wt.eu-S1753140AbXFGJk1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140AbXFGJk1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 05:40:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751035AbXFGJkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 05:40:18 -0400
Received: from mx-out.strefa.interia.pl ([217.74.66.54]:42157 "EHLO
	mx-out.strefa.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbXFGJkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 05:40:16 -0400
X-Greylist: delayed 1380 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jun 2007 05:40:16 EDT
Message-ID: <4667C6FF.9020401@akcja.pl>
Date: Thu, 07 Jun 2007 10:51:11 +0200
From: Maciej Rutecki <mrutecki@akcja.pl>
Reply-To: mrutecki@akcja.pl
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [2.6.22-rc4-mm1] ACPI Exception (processor_throttling)
References: <20070606020737.4663d686.akpm@linux-foundation.org> <4667B970.7000506@gmail.com>
In-Reply-To: <4667B970.7000506@gmail.com>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms090604090606040408090701"
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms090604090606040408090701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Maciej Rutecki pisze:

> ACPI Exception (processor_throttling-0084): AE_NOT_FOUND, Evaluating
> _PTC [20070126]
> ACPI Exception (processor_throttling-0147): AE_NOT_FOUND, Evaluating
> _TSS [20070126]
>=20
> On 2.6.20.9 I don't have this exceptions.
>=20
> Other problem:
>=20
> 2.6.22rc4-mm1:
> rutek:/home/maciek# cat /proc/acpi/processor/CPU0/throttling
> Naruszenie ochrony pami=C4=99ci (segmentation fault)

Update (2.6.22-rc4-mm2):

rutek:/home/maciek# cat /proc/acpi/processor/CPU0/throttling
acpi_processor_throttling_seq_show() is busted
rutek:/home/maciek# cat /proc/acpi/processor/CPU1/throttling
acpi_processor_throttling_seq_show() is busted



--=20
Maciej Rutecki
http://www.maciek.unixy.pl


--------------ms090604090606040408090701
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
hvcNAQkFMQ8XDTA3MDYwNzA4NTExMVowIwYJKoZIhvcNAQkEMRYEFDT3yPuAFumgJFkL+DVb
/WK74XF/MFIGCSqGSIb3DQEJDzFFMEMwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0G
CCqGSIb3DQMCAgFAMAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGFBgkrBgEEAYI3EAQxeDB2
MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQu
MSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQEvJZD92X
1FJUPBBDtFTjZDCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQK
ExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29u
YWwgRnJlZW1haWwgSXNzdWluZyBDQQIQEvJZD92X1FJUPBBDtFTjZDANBgkqhkiG9w0BAQEF
AASCAQB0Iaf7CWtmYLjj2Ojh2YctibdfGTcUAcDCSRtPoF7/XYBBljSLe7SsHyfP4baQqx3s
0ktTN7IvetDEPgoVGYVNC2BL0PmPrAq0PQ+FIRCiVKj41QJZaS39h1/1QsyzN903O/s+xPIf
H/VVXUY6NKIWFtWtnUSB7mVMWSGdg39fYA6lDfVx5dPE2AwRaO1yXu4HPhAMBl3bTaM856Ic
DNjmpUj+gpc853N4vkO6qlfytGdJppYN6PJ1j6BMfuZtRUqOu+KzHQiFFw8Ecby1BYkwv+cE
NXJUjOZsf/U2UDlbGY/8pDMX0LXjbr3iW7sllpspM74YqHOUkzxbc6YqlxBLAAAAAAAA
--------------ms090604090606040408090701--

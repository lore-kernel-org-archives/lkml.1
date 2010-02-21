Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141Ab0BUUFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 15:05:31 -0500
Received: from smtp.nokia.com ([192.100.105.134]:45788 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957Ab0BUUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 15:05:30 -0500
Subject: Re: [net-next PATCH v4 1/3] net: TCP thin-stream detection
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: multipart/signed; boundary=Apple-Mail-2-712678364; protocol="application/pkcs7-signature"; micalg=sha1
From: Lars Eggert <lars.eggert@nokia.com>
In-Reply-To: <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
Date: Sun, 21 Feb 2010 22:04:46 +0200
Cc: Pavel Machek <pavel@ucw.cz>, Andreas Petlund <apetlund@simula.no>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Ilpo J?rvinen <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Arnd Hannemann <Arnd.Hannemann@nets.rwth-aachen.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "shemminger@vyatta.com" <shemminger@vyatta.com>,
       David Miller <davem@davemloft.net>,
       "william.allen.simpson@gmail.com" <william.allen.simpson@gmail.com>,
       Lukowski Damian <damian@tvk.rwth-aachen.de>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Message-Id: <2EC47E8B-BC4C-4DAB-86ED-F702D67F8AD0@nokia.com>
References: <4B7AAE60.3070305@simula.no> <20100221102102.GB1311@ucw.cz> <D40945A6-301D-485D-BB8C-826D2EB68DA4@nets.rwth-aachen.de>
To: Alexander Zimmermann <zimmermann@nets.rwth-aachen.de>
X-Mailer: Apple Mail (2.1077)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.3 (mail.fit.nokia.com [0.0.0.0]); Sun, 21 Feb 2010 22:04:52 +0200 (EET)
X-OriginalArrivalTime: 21 Feb 2010 20:04:58.0170 (UTC) FILETIME=[249081A0:01CAB331]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Apple-Mail-2-712678364
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On 2010-2-21, at 13:23, Alexander Zimmermann wrote:
> I strongly suggest that we discuss Andreas' idea on IETF TCPM *before*
> we integrate it in the kernel and enable it for everyone

Agree with Alexander. It is not at all clear to me that these changes =
are safe for non-exerimental use in the wider Internet.

Lars=

--Apple-Mail-2-712678364
Content-Disposition: attachment;
	filename=smime.p7s
Content-Type: application/pkcs7-signature;
	name=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGbDCCAyUw
ggKOoAMCAQICEAdjk36sXKbnVn15S0/qUp0wDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA5MDYxNTExMjYxNFoXDTEwMDYxNTExMjYx
NFowXDEPMA0GA1UEBBMGRWdnZXJ0MQ0wCwYDVQQqEwRMYXJzMRQwEgYDVQQDEwtMYXJzIEVnZ2Vy
dDEkMCIGCSqGSIb3DQEJARYVbGFycy5lZ2dlcnRAbm9raWEuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEA7mR8A+Pn0/FsUkMX6Pyjw+FL3IFcJk8GaKV5VJ40TMI0Wh8oq20cqA9X
uqnVDW9WztKwH+o+msJenLwWpprbpJm4TImYGbnUJxYyN8gb81aiX1Bw2xCpJ5z3H2+8DsReJLuY
Rdl4bVvaIxLIL4odmfsRwzPyNkOK8LRtfl6OPcaDOlFWzbikULfIVGGu7BqK4lxQSpYwwpZkOMOB
6nnBSfUOtBEmqO+qZG/nL/JxWFV5vxQgg4XHbsMMTxFf6+ji18BD09BUIfDLTuJoCzFmQhrM9vLT
VuRhHWSL20LoafGjXv6mPt3i9IGJHpVb2dMQUgOgRyWHTKiUJVU/rUTdWwIDAQABo14wXDAqBgUr
ZQEEAQQhMB8CAQAwGjAYAgEEBBNMMnVNeWZmQk5VYk5KSmNkWjJzMCAGA1UdEQQZMBeBFWxhcnMu
ZWdnZXJ0QG5va2lhLmNvbTAMBgNVHRMBAf8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBADUx+67n98wt
I1vydB90HeSZP4Y64VCxxb0NxGGFvfc2+JdVKeHJ/xT+l+ygYKsWNwJJprkPi4WZ5G0crkq4VK1H
5drEJIztpSPVfWI05vPidaaGuuuCR+6MvJMtOTEYEvc/6eovBnkrzRf9x5x5EyuJXAWTeuBADg80
QI3vQ1tZMIIDPzCCAqigAwIBAgIBDTANBgkqhkiG9w0BAQUFADCB0TELMAkGA1UEBhMCWkExFTAT
BgNVBAgTDFdlc3Rlcm4gQ2FwZTESMBAGA1UEBxMJQ2FwZSBUb3duMRowGAYDVQQKExFUaGF3dGUg
Q29uc3VsdGluZzEoMCYGA1UECxMfQ2VydGlmaWNhdGlvbiBTZXJ2aWNlcyBEaXZpc2lvbjEkMCIG
A1UEAxMbVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIENBMSswKQYJKoZIhvcNAQkBFhxwZXJzb25h
bC1mcmVlbWFpbEB0aGF3dGUuY29tMB4XDTAzMDcxNzAwMDAwMFoXDTEzMDcxNjIzNTk1OVowYjEL
MAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNV
BAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMIGfMA0GCSqGSIb3DQEBAQUA
A4GNADCBiQKBgQDEpjxVc1X7TrnKmVoeaMB1BHCd3+n/ox7svc31W/Iadr1/DDph8r9RzgHU5VAK
MNcCY1osiRVwjt3J8CuFWqo/cVbLrzwLB+fxH5E2JCoTzyvV84J3PQO+K/67GD4Hv0CAAmTXp6a7
n2XRxSpUhQ9IBH+nttE8YQRAHmQZcmC3+wIDAQABo4GUMIGRMBIGA1UdEwEB/wQIMAYBAf8CAQAw
QwYDVR0fBDwwOjA4oDagNIYyaHR0cDovL2NybC50aGF3dGUuY29tL1RoYXd0ZVBlcnNvbmFsRnJl
ZW1haWxDQS5jcmwwCwYDVR0PBAQDAgEGMCkGA1UdEQQiMCCkHjAcMRowGAYDVQQDExFQcml2YXRl
TGFiZWwyLTEzODANBgkqhkiG9w0BAQUFAAOBgQBIjNFQg+oLLswNo2asZw9/r6y+whehQ5aUnX9M
Ibj4Nh+qLZ82L8D0HFAgk3A8/a3hYWLD2ToZfoSxmRsAxRoLgnSeJVCUYsfbJ3FXJY3dqZw5jowg
T2Vfldr394fWxghOrvbqNOUQGls1TXfjViF4gtwhGTXeJLHTHUb/XV9lTzGCAxAwggMMAgEBMHYw
YjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAq
BgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAHY5N+rFym51Z9eUtP
6lKdMAkGBSsOAwIaBQCgggFvMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkF
MQ8XDTEwMDIyMTIwMDQ0N1owIwYJKoZIhvcNAQkEMRYEFDNoWYjCmw9MfGJRVJ8IAgch1i3UMIGF
BgkrBgEEAYI3EAQxeDB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGlu
ZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBD
QQIQB2OTfqxcpudWfXlLT+pSnTCBhwYLKoZIhvcNAQkQAgsxeKB2MGIxCzAJBgNVBAYTAlpBMSUw
IwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVy
c29uYWwgRnJlZW1haWwgSXNzdWluZyBDQQIQB2OTfqxcpudWfXlLT+pSnTANBgkqhkiG9w0BAQEF
AASCAQCnv8uut+TlZs6F4lF2zLvJZVanVaowWkjAvrJAoTwuV9fxh8Xky3No3UENFyQHwplFrLv1
guOx3eD1Tx6n41fJOiDA/9QYGN8I9Hendq8wjJtPgN8b7g3uS6aRMyfcoBycQUtSzFGAmxlZ0gJI
uG8jXup6v+IjTxNozYwsh3hb31ctBtpGnzzWy+TF/P+7F/Jfe4YWM3oAoqOwhtamEKDSo9VttQ6l
146fB1Ucrs9CVCKeHjBkLL/ej0g+/M02T5VjkvnIxpogrIoawRALZWFRQK8A/VH7VFDKF3XfnHyV
DAzqD4/5HB/4nQMwD3b6kfYhLxSELB9GwiMq5nFsTlHGAAAAAAAA

--Apple-Mail-2-712678364--

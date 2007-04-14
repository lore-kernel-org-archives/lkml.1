Return-Path: <linux-kernel-owner+w=401wt.eu-S1161205AbXDNNcU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161205AbXDNNcU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 09:32:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030855AbXDNNcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 09:32:20 -0400
Received: from smtp4.netcabo.pt ([212.113.174.31]:6998 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030842AbXDNNcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 09:32:19 -0400
X-Greylist: delayed 547 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Apr 2007 09:32:19 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HAJByIEZThFhoUGdsb2JhbACPfgEBKg
X-Antivirus-bastov-Mail-From: sergio@sergiomb.no-ip.org via bastov.localdomain
X-Antivirus-bastov: 1.25-st-qms (Clear:RC:0(83.132.129.181):SA:0(-2.3/5.0):. Processed in 4.41894 secs Process 19647)
Subject: Re: [PATCH] pci quirks: Sort out the VIA mess once and for
	all	(hopefully)
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
Reply-To: sergio@sergiomb.no-ip.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       torvalds@osdl.org
In-Reply-To: <1163035093.13988.9.camel@monteirov>
References: <1163003156.23956.40.camel@localhost.localdomain>
	 <45523848.7010709@gentoo.org>
	 <1163018356.23956.88.camel@localhost.localdomain>
	 <1163035093.13988.9.camel@monteirov>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-MS8Cmk5N6Dkh7qiJvZNm"
Date: Sat, 14 Apr 2007 14:22:46 +0100
Message-Id: <1176556966.16992.9.camel@monteirov>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
X-OriginalArrivalTime: 14 Apr 2007 13:23:09.0219 (UTC) FILETIME=[0B3F8730:01C77E98]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MS8Cmk5N6Dkh7qiJvZNm
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Hi,=20
I don't have the original message just my reply,=20
I had try a FC6-respin dvd.iso ( which have kernel 2.6.20) in my old
laptop (http://sergiomb.no-ip.org/laptop/ ) which need "VIA IRQ quirk
fixup"  and I had many problems with booting after dig a little I found
that quirks aren't applied anymore .
So the latest patch of Alan Cox on this subject which is already on
kernel 2.6.20, hasn't been tested and doesn't work on my laptop and
probably in all compaq pressario 700 , I think.

Thanks,
--=20
S=E9rgio M.B.

--=-MS8Cmk5N6Dkh7qiJvZNm
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIGVjCCAw8w
ggJ4oAMCAQICEGne8YrzxxgYAeyxZxmiO+owDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MTAxMTEwMjAzOVoXDTA3MTAxMTEwMjAz
OVowSzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEoMCYGCSqGSIb3DQEJARYZc2Vy
Z2lvQHNlcmdpb21iLm5vLWlwLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAN9R
ix9koyWSNQDmAHxcSeWXdFO1osqg2yeNgBBl+fz8FLYyROsDGpZMcnOd/Df6tWwMZpMSYDNIksiZ
5VkCWaWIzIBccHX3wIkqrkcq3v1OcPGW9adXClXSbSZ0Hb4V4+bQ9LMAOjaMlH/dKLVkln6qmbko
NOxgPotdVxCGcUy1Pqa4dT1zFo5+nIv1NAUNqKpq63X/+3nILNG4JGAvLIL8wcYs0cETGS6vISgd
YFN/JlIqekWUGGUmc+SJcyyTWjXGN+2G0SDS8K3a9NFCo7a1Y0FyHQxikQRtB9sCcpQCoXiqaWsT
npSrNJ0Od4w1sHZz09uEdhWKqXEmJsKKwi8CAwEAAaNZMFcwDgYDVR0PAQH/BAQDAgSQMBEGCWCG
SAGG+EIBAQQEAwIFoDAkBgNVHREEHTAbgRlzZXJnaW9Ac2VyZ2lvbWIubm8taXAub3JnMAwGA1Ud
EwEB/wQCMAAwDQYJKoZIhvcNAQEFBQADgYEAwVE8/kY82qYG7I2+gW0NhSyn+DR0uAWYbSxB2NgP
16QOrzXt2HazlXkl2Bc+NKQEqEGKOu5fPPg2GoJ3zDO1Y8GUNGtJH0sX+63RGoUNOAv+bAK1Nxhb
illDUUCjW3OqA/hRyBwjU9kHJPYhl1EbAUGpAhfENHjkS/S7b1REBLMwggM/MIICqKADAgECAgEN
MA0GCSqGSIb3DQEBBQUAMIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIw
EAYDVQQHEwlDYXBlIFRvd24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9D
ZXJ0aWZpY2F0aW9uIFNlcnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwg
RnJlZW1haWwgQ0ExKzApBgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20w
HhcNMDMwNzE3MDAwMDAwWhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZy
ZWVtYWlsIElzc3VpbmcgQ0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZ
Wh5owHUEcJ3f6f+jHuy9zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuv
PAsH5/EfkTYkKhPPK9Xzgnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBly
YLf7AgMBAAGjgZQwgZEwEgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRw
Oi8vY3JsLnRoYXd0ZS5jb20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMC
AQYwKQYDVR0RBCIwIKQeMBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEB
BQUAA4GBAEiM0VCD6gsuzA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFh
YsPZOhl+hLGZGwDFGguCdJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVN
d+NWIXiC3CEZNd4ksdMdRv9dX2VPMYIB/DCCAfgCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UE
ChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEGne8YrzxxgYAeyxZxmiO+owCQYFKw4DAhoFAKBdMBgGCSqG
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDQxNDEzMjI0MlowIwYJKoZI
hvcNAQkEMRYEFKdyqjV1OhRNq9L5+AcO2oSAIM+lMA0GCSqGSIb3DQEBAQUABIIBANFNTZoaD9ML
xhw0Cv/ZWoI3tIvYiCYprppEOBhy7UmuVzFmvkiGUURSNAkdUyaKyIAsm0p4F/X9q0D1aYUdxrAu
W1dZor0zMNjpEZG33EeQqzk2T17yq6MGgNl9UGBdV0Q5b4/ITWPgNtkFj3FI9+rgNonYA9PvSCca
jrb3TDzjeQKd2AX1jHWvTbEc4Tz8xObTBsgHM+YPc1uGmFQ7ukFZQIPVhAJYS0gPtflvUd0fKZSa
9gpVdNOpcfFMXfrycSK74gqF9+jGAOdKWzk1Oqgvh0zRAMblrvL8QF9n21PB+gHSOfA6nD3F4wu1
pKPmKGueWKZuwYGJ1D7seJTleSEAAAAAAAA=


--=-MS8Cmk5N6Dkh7qiJvZNm--

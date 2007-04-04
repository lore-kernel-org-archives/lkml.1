Return-Path: <linux-kernel-owner+w=401wt.eu-S2993037AbXDDTNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993037AbXDDTNM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 15:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993040AbXDDTNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 15:13:12 -0400
Received: from relay4.ptmail.sapo.pt ([212.55.154.24]:36090 "HELO sapo.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S2993037AbXDDTNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 15:13:08 -0400
X-AntiVirus: PTMail-AV 0.3-0.90.1
Subject: Re: 2.6.21-rc5-mm4 -- laptop lid button only triggers suspend on
	HP dv1240us every other time.
From: Sergio Monteiro Basto <sergio@sergiomb.no-ip.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm@lists.osdl.org, linux-acpi@vger.kernel.org
In-Reply-To: <20070403224420.7dcfe334.akpm@linux-foundation.org>
References: <a44ae5cd0704032233sa893351le119152668557e72@mail.gmail.com>
	 <20070403224420.7dcfe334.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-pAPc+/ttDmvYBfLrB1Ix"
Date: Wed, 04 Apr 2007 20:13:38 +0100
Message-Id: <1175714018.15359.3.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-pAPc+/ttDmvYBfLrB1Ix
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-04-03 at 22:44 -0700, Andrew Morton wrote:
> On Wed, 4 Apr 2007 00:33:36 -0500 "Miles Lane" <miles.lane@gmail.com> wro=
te:
>=20
> > This is an old bug.  It has been happening forever, but I'd love to
> > know how I can help get this tracked down and fixed.
>=20
> Yes, I've been hitting something like that in the past 3-4 weeks.  We
> started to diagnose it but I got distracted.
>=20
> For a start, please review
> http://www.mail-archive.com/linux-acpi@vger.kernel.org/msg05094.html, the=
n
> see if you are able to take it further than I was.

I had a similar problem with my laptop that loose ACPI events, after
suspend to disk, on kernels (I don't remember well) works on 2.6.16 or
15, stops work on 2.6.17 and 2.6.18 and works again on 2.6.19 and 20=20


--=20
S=C3=A9rgio M. B.

--=-pAPc+/ttDmvYBfLrB1Ix
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
SIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcNAQkFMQ8XDTA3MDQwNDE5MTMzNFowIwYJKoZI
hvcNAQkEMRYEFLC4OtL/LseHxeCNWBXGjNUqem5SMA0GCSqGSIb3DQEBAQUABIIBAM4nDrpxDKku
mA0Uw2KTvWaa3upcztPHAPBsGxNQcqkthQyqGGzIiBotdVB0m8p6Giz4OAS5KFtEwbefNHVqxK6r
N2R36tBVEkMWYgbS9VSE/hHt6+cmDGNnCNWBY/mw4Gz9q3H6Olh/uAGhusUIZp3JYDWbpU8irtS3
gWAhRjd1RkJFGLQnAXqAZ03hzIRZM7pfF/H+CE3zFw7+xCRtkOgZIkh9+7AXmvSq84OZh78yweCs
BexvE+4yHJjKcP4hNdwE+SnPVUAK8Op5a7NL5hyKBnSMUkvehiz9u9U3ks0nVRypk5ed3Kmcpu6C
p56KSRbsH/eWIlP626ab7SRSyPgAAAAAAAA=


--=-pAPc+/ttDmvYBfLrB1Ix--


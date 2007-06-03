Return-Path: <linux-kernel-owner+w=401wt.eu-S1763773AbXFCBMg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763773AbXFCBMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 21:12:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760616AbXFCBM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 21:12:29 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32963 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758519AbXFCBM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 21:12:28 -0400
Subject: Re: 2.6.22-rc3-mm1 reiser4 bug
From: Zan Lynx <zlynx@acm.org>
To: "Berck E. Nash" <flyboy@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com
In-Reply-To: <4661C0DA.7040308@gmail.com>
References: <4661C0DA.7040308@gmail.com>
Content-Type: multipart/signed; micalg=sha1; protocol="application/x-pkcs7-signature"; boundary="=-8LHACtYBcncauxGcMk/b"
Date: Sun, 03 Jun 2007 01:12:18 +0000
Message-Id: <1180833139.7501.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8LHACtYBcncauxGcMk/b
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-xOB1vbpi7+pyMOeGoGIi"


--=-xOB1vbpi7+pyMOeGoGIi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-06-02 at 13:11 -0600, Berck E. Nash wrote:
> All appears to work fine, until I try to boot a kernel with a Reiser4 /
> partition.  Then I get endless errors of the sort:
>=20
> [  206.349450] sd 1:0:0:0: [sdc] Result: hostbyte=3DDID_BAD_TARGET
> driverbyte=3DDRIVER_OK,SUGGEST_OK
>=20
> (See attached dmesg for more, I only sent the first 1,000 lines, it goes
> on until a hard reboot.)
>=20
> The same partition and the same kernel work great as long as that
> partition isn't the current system root.  The same kernel and the same
> hard drive works fine as long as the partition is formatted ReiserFS.

It can't be a simple bug, because I am running 2.6.22-rc3-mm1 and
Reiser4 on / right now, and it works well for me.

I am using a busybox initramfs that does the actual mounting.  I don't
know if that makes a difference.
--=20
Zan Lynx <zlynx@acm.org>

--=-xOB1vbpi7+pyMOeGoGIi
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGYhVsG8fHaOLTWwgRAja9AJ4r5EXMxibfhvoBu8ccxWENkV1oTQCfcz2X
ppwzEbChjdodm0w8/fKNAhc=3D
=3DIlQB
-----END PGP SIGNATURE-----

--=-xOB1vbpi7+pyMOeGoGIi--

--=-8LHACtYBcncauxGcMk/b
Content-Type: application/x-pkcs7-signature; name=smime.p7s
Content-Disposition: attachment; filename=smime.p7s
Content-Transfer-Encoding: base64

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIII8zCCAtQw
ggI9oAMCAQICEBmv7WBciYMnO0zg9KmbGQUwDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQ
ZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA3MDUyMjE5NDYxOVoXDTA4MDUyMTE5NDYx
OVowPzEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEcMBoGCSqGSIb3DQEJARYNemx5
bnhAYWNtLm9yZzCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBALi7cy1U27KrA5lA/KVg
o6U8a8v5gCfscOX8i2dMvknRvug1jE/P+Tqkv/R8+ThgWNtCLxG3siF2+ZTNqbv+9wOYemwjcjiG
zPxcz8AguL/eTLmShf/JNGus6M0wxtW94u6Ghmu2q6nWfE5WSaiLugPItk4zZzqJsQN7S0sIGetG
WjJGo18ZKu58CMHHhHEnmPi8uQfPkxnjktSBM78DdbBYhnFssmhC4yaItPJlla0Cxg5TZe74cNwt
3KTfE+F3R9IQ+/hPlXMnheifTJdK5Hh/Uy4/wgvV4RvvnLerKjA9bLzSnkth+Kp0Qq/uBL+NG5uw
cKu1/f9pYm2eo5OinU0CAwEAAaMqMCgwGAYDVR0RBBEwD4ENemx5bnhAYWNtLm9yZzAMBgNVHRMB
Af8EAjAAMA0GCSqGSIb3DQEBBQUAA4GBAMGVms8JNsdEQWxf5ubEqUmtqseXSOkWOc06LQ1WWgDF
9rGw3toh+Uupx7QXiF0BszZ65p16TdmwgrTYN8OznlGlbQFlYO1gQhgbqBpJAiVocRiVAAaLlJ76
ESZC/oQJ5Yk2RX+IKJOwtUuOVVt/XPJpqyKSX+QduzAfzt9rIB2tMIIC1DCCAj2gAwIBAgIQGa/t
YFyJgyc7TOD0qZsZBTANBgkqhkiG9w0BAQUFADBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhh
d3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVt
YWlsIElzc3VpbmcgQ0EwHhcNMDcwNTIyMTk0NjE5WhcNMDgwNTIxMTk0NjE5WjA/MR8wHQYDVQQD
ExZUaGF3dGUgRnJlZW1haWwgTWVtYmVyMRwwGgYJKoZIhvcNAQkBFg16bHlueEBhY20ub3JnMIIB
IjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAuLtzLVTbsqsDmUD8pWCjpTxry/mAJ+xw5fyL
Z0y+SdG+6DWMT8/5OqS/9Hz5OGBY20IvEbeyIXb5lM2pu/73A5h6bCNyOIbM/FzPwCC4v95MuZKF
/8k0a6zozTDG1b3i7oaGa7arqdZ8TlZJqIu6A8i2TjNnOomxA3tLSwgZ60ZaMkajXxkq7nwIwceE
cSeY+Ly5B8+TGeOS1IEzvwN1sFiGcWyyaELjJoi08mWVrQLGDlNl7vhw3C3cpN8T4XdH0hD7+E+V
cyeF6J9Ml0rkeH9TLj/CC9XhG++ct6sqMD1svNKeS2H4qnRCr+4Ev40bm7Bwq7X9/2libZ6jk6Kd
TQIDAQABoyowKDAYBgNVHREEETAPgQ16bHlueEBhY20ub3JnMAwGA1UdEwEB/wQCMAAwDQYJKoZI
hvcNAQEFBQADgYEAwZWazwk2x0RBbF/m5sSpSa2qx5dI6RY5zTotDVZaAMX2sbDe2iH5S6nHtBeI
XQGzNnrmnXpN2bCCtNg3w7OeUaVtAWVg7WBCGBuoGkkCJWhxGJUABouUnvoRJkL+hAnliTZFf4go
k7C1S45VW39c8mmrIpJf5B27MB/O32sgHa0wggM/MIICqKADAgECAgENMA0GCSqGSIb3DQEBBQUA
MIHRMQswCQYDVQQGEwJaQTEVMBMGA1UECBMMV2VzdGVybiBDYXBlMRIwEAYDVQQHEwlDYXBlIFRv
d24xGjAYBgNVBAoTEVRoYXd0ZSBDb25zdWx0aW5nMSgwJgYDVQQLEx9DZXJ0aWZpY2F0aW9uIFNl
cnZpY2VzIERpdmlzaW9uMSQwIgYDVQQDExtUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgQ0ExKzAp
BgkqhkiG9w0BCQEWHHBlcnNvbmFsLWZyZWVtYWlsQHRoYXd0ZS5jb20wHhcNMDMwNzE3MDAwMDAw
WhcNMTMwNzE2MjM1OTU5WjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRp
bmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vpbmcg
Q0EwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBAMSmPFVzVftOucqZWh5owHUEcJ3f6f+jHuy9
zfVb8hp2vX8MOmHyv1HOAdTlUAow1wJjWiyJFXCO3cnwK4Vaqj9xVsuvPAsH5/EfkTYkKhPPK9Xz
gnc9A74r/rsYPge/QIACZNenprufZdHFKlSFD0gEf6e20TxhBEAeZBlyYLf7AgMBAAGjgZQwgZEw
EgYDVR0TAQH/BAgwBgEB/wIBADBDBgNVHR8EPDA6MDigNqA0hjJodHRwOi8vY3JsLnRoYXd0ZS5j
b20vVGhhd3RlUGVyc29uYWxGcmVlbWFpbENBLmNybDALBgNVHQ8EBAMCAQYwKQYDVR0RBCIwIKQe
MBwxGjAYBgNVBAMTEVByaXZhdGVMYWJlbDItMTM4MA0GCSqGSIb3DQEBBQUAA4GBAEiM0VCD6gsu
zA2jZqxnD3+vrL7CF6FDlpSdf0whuPg2H6otnzYvwPQcUCCTcDz9reFhYsPZOhl+hLGZGwDFGguC
dJ4lUJRix9sncVcljd2pnDmOjCBPZV+V2vf3h9bGCE6u9uo05RAaWzVNd+NWIXiC3CEZNd4ksdMd
Rv9dX2VPMYIDEDCCAwwCAQEwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1
bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3Vp
bmcgQ0ECEBmv7WBciYMnO0zg9KmbGQUwCQYFKw4DAhoFAKCCAW8wGAYJKoZIhvcNAQkDMQsGCSqG
SIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMDcwNjAzMDExMjEyWjAjBgkqhkiG9w0BCQQxFgQUnjK1
dL0/FdxJ0tOrZqRfaiYzKuUwgYUGCSsGAQQBgjcQBDF4MHYwYjELMAkGA1UEBhMCWkExJTAjBgNV
BAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25h
bCBGcmVlbWFpbCBJc3N1aW5nIENBAhAZr+1gXImDJztM4PSpmxkFMIGHBgsqhkiG9w0BCRACCzF4
oHYwYjELMAkGA1UEBhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4x
LDAqBgNVBAMTI1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBAhAZr+1gXImDJztM
4PSpmxkFMA0GCSqGSIb3DQEBAQUABIIBAFBT7Qg2pyV+iQwRAOZdV1hfbiIciv8AouKWMvBUZnh2
qzmr4jm6ACfufqy+B2KYdvzPi+SZ0Hx6BGvGIryeSGPMM71hUvacwAU2qKfZt413CJbvuIbIE+5k
oFiJxnxEh0rPVlMiQaqCJVil7BF1/R+gYkYzvUdWq8GobhAj0zecPHPMTw79AyZBBOk7suteNsU3
27ondvy0ORSUYsrXqdZ7OZq4Ca/nTpH/qwTJDoZ+jWQzA0NUtG/jZiqPHAy/Wbtb4BMmMHEGyz74
i4LVq3MDVgnr/Qg3dVTkknJ6zLup+hDHXWVJrUWT5gdl0bckOfz0lIxkDCXEKIht85dphmcAAAAA
AAA=


--=-8LHACtYBcncauxGcMk/b--


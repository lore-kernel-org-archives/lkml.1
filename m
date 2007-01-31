Return-Path: <linux-kernel-owner+w=401wt.eu-S933104AbXAaLyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104AbXAaLyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 06:54:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933113AbXAaLyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 06:54:25 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:6658 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933091AbXAaLyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 06:54:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type;
        b=rB7UgW1YiH7pn9Nk5v6AXPciHWugtZh5qYeMp+nu3LBYP4vdUMaaddRGmIFDIC+faGNAEbaqgXotfHVekY/aHBiCD5k4TU7cQHNXYr/g9PiQT/vX0zXZoYs/L7o7T05yo8hEaXaKlzhKV5dVk8wGc5/BXf6eyh/T5noO6qQf1MQ=
Message-ID: <45C08368.2020904@gmail.com>
Date: Wed, 31 Jan 2007 12:54:16 +0100
From: Maciej Rutecki <maciej.rutecki@gmail.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: 2.6.20-rc6-mm3
References: <20070129204528.eb8d695e.akpm@osdl.org>	<45BFC442.5000903@gmail.com> <20070130142714.9f8dd5da.akpm@osdl.org>
In-Reply-To: <20070130142714.9f8dd5da.akpm@osdl.org>
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms070304000904080406080109"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms070304000904080406080109
Content-Type: multipart/mixed;
 boundary="------------090306000001060400040904"

This is a multi-part message in MIME format.
--------------090306000001060400040904
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton napisa=C5=82(a):

> OK, thanks.  That might be due to the time-management updates as well. =

> I'll see if I can reproduce this.
>=20
> If you're keen, you could test just 2.6.19-rc6+origin.patch+git-acpi.pa=
tch
> from
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20-rc=
6/2.6.20-rc6-mm3/broken-out
> and see which of these problems remain.
>=20

I try 2.6.19-rc6 witch origin.patch and git-acpi.patch. This patch
didn't add correctly (see patch_output.txt). Also I have compiling error:=


AS      arch/i386/kernel/entry.o
  CC      arch/i386/kernel/traps.o
  CC      arch/i386/kernel/irq.o
  CC      arch/i386/kernel/ptrace.o
  CC      arch/i386/kernel/time.o
  CC      arch/i386/kernel/ioport.o
  CC      arch/i386/kernel/ldt.o
  CC      arch/i386/kernel/setup.o
In file included from include/acpi/acpi.h:62,
                 from include/linux/acpi.h:37,
                 from arch/i386/kernel/setup.c:31:
include/acpi/acpixf.h:100: warning: 'struct acpi_pointer' declared
inside parameter list
include/acpi/acpixf.h:100: warning: its scope is only this definition or
declaration, which is probably not what you want
include/acpi/acpixf.h:115: error: expected ')' before 'table_type'
make[2]: *** [arch/i386/kernel/setup.o] B=C5=82=C4=85d 1
make[1]: *** [arch/i386/kernel] B=C5=82=C4=85d 2
make[1]: Opuszczenie katalogu `/usr/src/linux-rc'
make: *** [debian/stamp-build-kernel] B=C5=82=C4=85d 2

"B=C5=82=C4=85d"=3D"Error" (in polish).

--=20
Maciej Rutecki <maciej.rutecki@gmail.com>

--------------090306000001060400040904
Content-Type: application/x-gzip;
 name="patch_output.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="patch_output.txt.gz"

H4sICKCCwEUAA3BhdGNoX291dHB1dC50eHQA1V1rj+u4ef4+v0JFPjTB1raouxYFggWSoEGa
otjkWxEYtETZ7Oi2IuXxLPbHl7pYpijePOd0z+QAM/aRHlEv+ZLvnZwKZhi9fn/oSXcgXXYo
cd3fdl32G6eFNLs4uxY4/+40HT7jej9eehl/4/rsFLhEzh+arK9QTSHFTX0YLpF3QlFFDmm7
pzeqhWM/iQ6npqEj8j/6+tX5DXD+9MOf//OPf3Agdbz9fNFzSJ9lCOUoH66DxHN+2xQFQdTZ
BQ4jGpHf7V+A0/TUaQrHcy7sMXJvabdzCLwONHTof1FGiUMbIzl7hhWI/+sPf/6vv7OfP/74
t4XYFV1p6D7oAkm8UCbvRQwS5w3Ti1P0P//scF3ygCs86q8f9WI/5uBhKMCDNdz3PcDD/QW+
7iDssssBXjvfO2RNXeAzOUBK6CtwXe+Yo2K6qH7oFXU1Kqf/HF/Je0X2mQw9DvQMZqPfve8V
A+ql6YNuLdV8k2wGslZRx14ubTUOZbNHyqMUqKECT4CfqLGBOIEjGVbSr7Z5Q12bHf4yj/12
kQRJ8CD+cTn0ov2L9/SKkL1UshRWsHnY2wwfo0A16MDnx9JPbTo9N3zNScOazWD9r5Sh6nyC
MpInIcVax3XLOjo06YA0Tl/+G3UX2BLnvemdnjAK6AU5b13DXrNrmTxjI0Boh9nXdlj6v3/5
O7tP0Y21gWA+UNO3wwvoBRPnDZLvX3bKfy+/5LgoWItnTB14WPWgLSEtmo6Jw5b4h7/CVzSS
frJBvfzCuopujh+HcVbA/R6kaZC6gcOWYxQEL7+wd9u97+WX7777zvKlmn7+iR/171/+9srG
bxyg8cLvnf95/8d4sR3Gb7zGyWQwzkAHn+umQ7k9M1P3kzITDyKm61u6z/RDywHvLHXDKAMo
2O+jIsxR4NuzdNWYkas8+ldirGQ5k5Z9RMEinvs6uB5peTpWmBAm+iWP9NUifAbJLoPckoiJ
mwOGTPEMv44nXBcVlWscHszUQwbL0vc20LzDV9QxpZe1+NB2TYYIabpji7qixCeVZPO9YBFs
nkKsLS1TuIhyNQJeMqxUXgFnYhgMDF57GrRXEnD2RyQ2LKovl+vyLhWNlVBEM4NDhtYMAIXH
M6pRhzM1kxiOcYV97DI281Tj5XkuZ5R5PrB4/dwsKQolF1KuS77BiEh4Y20DFhkRBhqwwIiE
GcIPC5LXr6JFKPAkSRMpWD0m7cCTrMqj4KZlyYi7tNS/ebUZiGnigZu9cvdCJiW/oT7YduDW
BrfbMStGLaC7fZf92SlJvQDs955/SiA8CbJf38Qk8bWYryznNyakXNBvSCrRGWbv5hnQ/cz6
72pxZMD1JTaDrhguK1YUhl6iFpyie+VKhaz85QXuqjfYoQOzn66w27o8dyAmeX044zNkzTL/
qqqaWqlSOPHiG9zIAARqrNCxCKRqrCBbothTYwVxErsabCRgfVeNjQVslKixiVokb7CpqJJS
DRHM+16jAec+b9GiowN8zWAAcVqCUEq2rTxMA/8zyMPXazX87C+cdFqu3SVfCpCbxSGTfPkJ
ZFB0ZCTPrcXd48avZMtaMyEMPxETjhXE9UodrW/c2XFCQRQC5lee2HKIPaRnx/KwlCf3u1+Z
MeGdMaGgfCw547sAfBbOVFW/Ycp4bTEMooKxIWXLw8sCL8o0/Jif27JiuvGVueDfueB/lAuh
91m40MIza+tIq7bcCKvVvTtXolMWgJQJLRCkBQxCDVeE57fcWQO+MpeSO5eSD3KJWT2fhUuE
SXlxrYzX7lyJ/TQ+Faf9Ps1itygiDVfm57bcmG58ZS4Edy4EVuZylR9OmFawVVqNDJFXyqCq
G8fSoKrCBPYiDdrnosfAdxOV8x+4nO8bP1oBYteNwWahj5I4M4eocpVp74cR7/rqTeDQ5R2B
yGDcs/d2EOdAyQAv8tWv9kS3In3+1aHq1Ss2eJs3c1m0KE4Ug+G7AZ9HcsMtM/0PMHOmW8PP
mrlAp/rmcZ3jUhexYgDD2OOiVMDzt+RaJzq2lGjI7Wg2/OzIOynUDh4ZooY36DFPnH1Vr1mf
yz8BX5X+4VudmvsRDRdYK79lgrjt0BU3PSnfHdi2JUb572axniPKeoryf3GcHwjpK+TsfmTC
qv7Hyw8MyOD1+xt8n67YevsWA7nQqRnHGXMkfuYFt20gqRjSxgfUdU2nuFfgXDWwXiDPphqi
pIkmoCqm+PglZ4qReqE5hvDok5hXn+5UvWqMruk4EeWSIYxsX30tyHH4r3wdhqohc2XtP78G
RRokM+cBwXWTI9loTHH/IyqV0dooefBtolepIkHyiJCIQlWcDYGvxm6UJjdmIlaMl4dRpMQK
wRQQ+RotEIvgODXrn9WIHou8HWPw8hXHBbZV2fmhub4oxmz85xRgHIXyCViQ3VuHKTrB7FU2
AeuC5MMv/5Yraw7S9CFmVBKfayrQNAWS5Km2yHWbROFua94URA/+qnIE95auEsXI7jVZQbzp
95EhLjIxk8TbEIyN7BDblnNvyOMdTpDIZZwfg4+9nGtW8l5cZ2WfowMk1W5OZN2zSm3TjQa/
KPH5R8ZqlkGgGUEFvlk1xlxPxI2+IJyATIaoW7wnm5/o0ZyA7WE2JFWVlITJVlDLGx0r1Qbn
qWmH5iyd3OAbh+rW1N8jppKrS5AuS05BBPZ7cEJMiRSCoyt9cnJ1Zbe+srNrVwOwJmSaM1JB
AGKV4R+5nDGVfIHFIadFs4DvQEKV03uCVJVyUnPq3Li85sZ6Nt0ML7zL763tKMcVFxvgoA3s
YL4BNziBg9NuQFGbvpK+HuTNoMn0QIorpO7A4Oux0afRMWvqmk0MtrqPpGFa/fJr2CaK5WIx
XTWEa+bu/al/1t4+39n2n6JrrbQjVXWoUNV070prO0y5YI2qgJI1Q7u+ziBVOHVAlUd2+Qrk
+AuE7IoESU+HQcizrD2whplmlpIJPGlVq59+qKp180YVVSgbP+pjjq5K+xsAXqCrGDGx+how
E+10ZObE1nddELg9LkPxKaevjFLFEI4w9oVdoKh71JXKHQw+YqOKmvrysI5Y4bQKXwPwkRCm
hv6xt5ZGZhik37QCWdKNujjWkB7blrZjYsUEWQpVIQrCU7zfh3kRFBkUzE9zM5MtasR9E8N0
oYpm7XHkn3qJDpBfc41+II4hpVW9SiOFRfG5RZCS6qcWaBh/07KAoS+rlTD0hnYwe12vUC3m
vkQLtyhcF+33WZjmhS/WE1q081ijeuA3W6QtI4J9wOI4fVOWzYWaGr9N2Zw0iC2N9AZebB33
DyJNu0KkN0g09AqR3jDS5CmEQG+oa1csm/M1fRPK5uJYmv/YMoxktB0iZLTJmvIzSxSBUIW0
5NxPmYJ43J4FqCJVHPA116oyeIKyvsP0/UDQ5NLeXYdb0SlDDIEntZFEE0lYAnEgLR4Hqpjy
hjRC2NfuijNEFEZ8msqseOA/Uksrsy0Zrm/KjYx2m56wkanDv8pqsysT0bthA4jFdtcrzlGz
m1XtdrPrY2PiY++kImGXyMJbqtbu2yyHXSrjdtVl7FeuUvDwoGLueuKnnHnhP7czUPF+1Q7B
DRzBrnz/qcedeplI06ZyzyA1S6MNGVnbDz9Fh346lEzZX2BfqjMtsdz32BZ6cOUWQSyb294j
uBnwl1NXpRy4Yh0grmRROXDKjMMuKyn6MJPlw2XD76ptYUeU+3KAG6qzp5usLJBlRFUEsHV+
2SESu657mD42EUEdeNhCp9m33Gb4UFXz5jSlIWJvh2jUr1i6JJ3viuoDzcZlMd+cSvdDy/oP
H7v4RhG5dD8V4/WBZrEI5fVREGrAYio/1NVbiWmDNNKAxY1XnnSv+QwWN14FmoozT9xsFbsa
cCSCdWQIht56G5cIFiy9FEhHw7Y8FIBvv616nICkvs9B3Bzv+2ju+2DViLu/lAd5nhTBfu/6
gZucxLJ3YyvcplsN7Cv7SpEoyTXbbTdUVY9Q5soKi1TbnzQlJcEqd84ZEtZFn2oaVVplzh3f
D4wYTIjdaEMojpdY48+ohpoalpBbyLFO+K1bNWi3xJWV+xhbHdJXS5OCyElXjpoNqVXFzFyV
LpsxgjaTl+2Nppt4AoWgzaUlZ3Jt7ku9U82rlyCyBgNJT44rpaQzInZgW9zFh4+9VKVYfe70
EO/hxH28+FmkXlM+OVnckFLEZYlEp44r/lPVZAntaXZpjoASZq9jBlwP6x9OoGi4xBo9HIhG
jsbOFhRrBKSWg4ZINocpZDB1cVUkqUCRzyeuU4paldWrc0zGu6g75KTAqMz147nC4xobhn8F
rxC9NM+0X9FLLpEU6gea0zCbn3mgzWT1m+oHeopLda31Fv+GbkhzWsAWXzbwmSF6I1nTPtOB
N0KnJKzmAaTUSynn0vnJRqI+hFXqJV9S/76QYZI76IpqSoaP4YuhW3fs2TRiPPJUbssr5eAK
k0ylJ303kYe11qtZECV+kKqQgoHux0qkYJ3zO7MFpGCaB76yQFnwrELOsBCQ4rblkDslzUZA
LaPboTNuNIc3rMHnmgknSzDJbJG3Ama2U+dWoKv1jLwVrHumzjFJ0g9ZEHSzsYzW8GtnIoWD
d8gsIh7wvK/UG8VEsIWK4dFljhtr9Lz+LMFjgVcmn/lelKxrAOzarGGFDMqBQzfMVj+D5+CG
04FEuP8cPLKGtx2y57nVyuXhpH5i+jF4U16fgtuTTuh0iM8TaPuODvDmZA8fj7C0hltYKgV8
nPWxqW9RWpyiXx4Yq6NXLz2XPfqsyTcJoSYD5AK7fDxo5fI2+3l2YKMNwmHZAjJwkgOTEpnW
JoeeSlO16KqhzHQ8NewhPXAUfy3TkIeazBX19viybAzCm4ebdY6Izg0igsejKyzt0WYviEeb
7XsebaFReLiN/8Pj79EiSzhBQ5DGHm8hgnj4GzSZ2jx6sK+eYdOtGP73DJ6NpgHeV1CPaEip
krDMUZeUGYq7+ZJYErGTehgelzAxHvg3HiU4ML87tIRpfgOXFmjZmJTnArVxrRewxURcsBYe
74KlHbKFWkzWBWueqQvUwmUYjqhl/FImn0O1xybOKel0Mby6WyXrxfDkExFUXS2QZl7bRVsf
B1+uzlUMRe/S5d1shbMcce6qGMwTvOWIS5qKUMFpSMDDEBKTm4K/nHDhUBEqOsxJEqqxm4C3
G0nDDKbt/MIQ47xURvw97qQ0UxLXSzSHWosRDF27sRjt4MKxYhhKYIvPnzcqYgW+BG6sxoqM
CQJfAxYzxEAHFjPEng4sZoj5PO4GvDkjNdGMHBBz8CCUtm01h0zn04ZPnE+7bpleuoZS9ogh
AjK4en3HHjp0BOa5wczl0RksDcboCm0RL+HxZuOVR+O6MIRAVuhnsN1P9mBzqoVHL3uGbPHG
0A2PtlDVPNxCBTOOc8debs8zkiRV5EsX8FpQxIpK0AuVQdvNwvVddbvisvVTNb3iUQ2Br25X
PKkheNLVH13RceEaRt8iskHhqUR8Lo8vGUi+ONV5b97k7k84q9zvDKUnm/DrAi5gbg3FtcGV
XKBnZNsoQzJf3BKMa0JNPtgCZoLPlgiLBb5g76t7m4MK0r1ktnhgVWn6BbPl8XLLWTPgZ2tb
B76groJKvxH4z+bSh9HEFDMCemoRZ+HhGcwuBtG5gjetQejz6Byd+rOUcyABKschlRb7f/xg
MBVVJpauHymRyQDg8ebABY8+l83pGbw5HsWjK0gNEZ0V2qinV+g5x2IJt4le8Xim47snqLFI
fPNwC6thrLRXGrjA2nOWn4wlnf+x5gixbVGQ9Z4fvsDEtOfHe2bPj6/ZdyQ4amGgGQbRJuM3
CJlMMh9ovO3N30vyZccYqYyy8EFFZHKmIn4/hSf+eYqNYZZEPPtM5zJmF9gdcFvh8deR4COu
qfLoMcCX5u+8VHdQIwhDVUkmCPlKXy+VFJ49LY9VHdHI4/ER2lbDz/GEG7XlsJyK32a52gUb
qg8vDW3L/jyu8/bSHuesleKBuh1+Rpmg/zsqA9Jg7Y5C5XEIwRq0HF40vApmcx2A8oijCTVp
NBMIE0gqCxS7b0JNZQ1G1C1DmuOZJtCs/Ayoy8BUE2j8s0PGFzLzyPy+CmZdY+zglLyxARmp
mlWjCTWF3E2oaWoZUFMA24jCZsRxqME0o+b5b0Y2zKE3o0bM1vpPI4W29F3pDofn3UopJbrD
2CbcZMwYukVo15unwezLmlAn4zRnEGCB8Swwsbmh99ZM9OQY6kFVabEKqtJiwO9/tmwQVvXV
GnvO7Nsdd3uaD8qbV5rUekyAdDugZzoolJvwG6xo6IBYjd1EnyI1dnNQqBRrGAx+c9zw/Xjf
9qAdxmFvxzyMw/6fetj/M8Kdt6Yvc2dy4sa9Q/KHST0//28vbxc81KY0iDh1Qx10w4R+xQoV
TTfmDRK6+RCn///zwdO0uzk4NrHn8bRRetU7MRlqf4ZypPHAxD9BZL+JMdGctix0PdW0Kq4E
+Q5j3SiNhuJx0eb/BxKon8s1eQAA
--------------090306000001060400040904--

--------------ms070304000904080406080109
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIJHzCC
AuowggJToAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UE
BhMCWkExJTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMT
I1RoYXd0ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloX
DTA3MDgyODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUG
CSqGSIb3DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlK
ZsRSZnkKTdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocT
wj1GzfReeGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUu
UuVtCdJosQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJ
JHdmqKTgjMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgff
iQIDAQABozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0T
AQH/BAIwADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCW
CAfCyORrFaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE
4I1hcOKz/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAuowggJT
oAMCAQICEE6xoJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEFBQAwYjELMAkGA1UEBhMCWkEx
JTAjBgNVBAoTHFRoYXd0ZSBDb25zdWx0aW5nIChQdHkpIEx0ZC4xLDAqBgNVBAMTI1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBJc3N1aW5nIENBMB4XDTA2MDgyODEyMzAwNloXDTA3MDgy
ODEyMzAwNlowSjEfMB0GA1UEAxMWVGhhd3RlIEZyZWVtYWlsIE1lbWJlcjEnMCUGCSqGSIb3
DQEJARYYbWFjaWVqLnJ1dGVja2lAZ21haWwuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A
MIIBCgKCAQEAxmrZ/vMNBQsTG+9oNg9WeFTNtluscxhg5oBwudmsZhsoDdtQYPlKZsRSZnkK
TdEWR9w8dwi0JBxmq1XHumBA6/rFfAfhbOV1SBH3ktZ9foamMjpJTjO3+3gF9ocTwj1GzfRe
eGZuPgr4qVVvOT5FfD/PkAJzvur7fyLnviiZokQz8R3c+VhJlW3HurhlOlK0ItUuUuVtCdJo
sQRepYdPQ6H3Mvn74UxVttDeVxWNlQ2DaS7cy8wTmtc5CTNMVctbJkzFz0a/7wCJJHdmqKTg
jMBm+ry/IC50jvwkLKAumSJBLWhoIB+LxkJlMwgn69jc0KJkrdkpsUjPdo+zDgffiQIDAQAB
ozUwMzAjBgNVHREEHDAagRhtYWNpZWoucnV0ZWNraUBnbWFpbC5jb20wDAYDVR0TAQH/BAIw
ADANBgkqhkiG9w0BAQUFAAOBgQC2O4xAuM7DplCDsgJuaMKz3uR25rq9ucMqVtCWCAfCyORr
FaxN8LFF9KcYx6M4AK1fQ36JVPtMER2VzGMF74gXgrFQ4A9tno6rKzi/QpzwWoPE4I1hcOKz
/YxOK0sRjSDR3p5s2XrKVxgUe+TEeJ6/y1iv52o41oYVmilsUovvHzCCAz8wggKooAMCAQIC
AQ0wDQYJKoZIhvcNAQEFBQAwgdExCzAJBgNVBAYTAlpBMRUwEwYDVQQIEwxXZXN0ZXJuIENh
cGUxEjAQBgNVBAcTCUNhcGUgVG93bjEaMBgGA1UEChMRVGhhd3RlIENvbnN1bHRpbmcxKDAm
BgNVBAsTH0NlcnRpZmljYXRpb24gU2VydmljZXMgRGl2aXNpb24xJDAiBgNVBAMTG1RoYXd0
ZSBQZXJzb25hbCBGcmVlbWFpbCBDQTErMCkGCSqGSIb3DQEJARYccGVyc29uYWwtZnJlZW1h
aWxAdGhhd3RlLmNvbTAeFw0wMzA3MTcwMDAwMDBaFw0xMzA3MTYyMzU5NTlaMGIxCzAJBgNV
BAYTAlpBMSUwIwYDVQQKExxUaGF3dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQD
EyNUaGF3dGUgUGVyc29uYWwgRnJlZW1haWwgSXNzdWluZyBDQTCBnzANBgkqhkiG9w0BAQEF
AAOBjQAwgYkCgYEAxKY8VXNV+065yplaHmjAdQRwnd/p/6Me7L3N9VvyGna9fww6YfK/Uc4B
1OVQCjDXAmNaLIkVcI7dyfArhVqqP3FWy688Cwfn8R+RNiQqE88r1fOCdz0Dviv+uxg+B79A
gAJk16emu59l0cUqVIUPSAR/p7bRPGEEQB5kGXJgt/sCAwEAAaOBlDCBkTASBgNVHRMBAf8E
CDAGAQH/AgEAMEMGA1UdHwQ8MDowOKA2oDSGMmh0dHA6Ly9jcmwudGhhd3RlLmNvbS9UaGF3
dGVQZXJzb25hbEZyZWVtYWlsQ0EuY3JsMAsGA1UdDwQEAwIBBjApBgNVHREEIjAgpB4wHDEa
MBgGA1UEAxMRUHJpdmF0ZUxhYmVsMi0xMzgwDQYJKoZIhvcNAQEFBQADgYEASIzRUIPqCy7M
DaNmrGcPf6+svsIXoUOWlJ1/TCG4+DYfqi2fNi/A9BxQIJNwPP2t4WFiw9k6GX6EsZkbAMUa
C4J0niVQlGLH2ydxVyWN3amcOY6MIE9lX5Xa9/eH1sYITq726jTlEBpbNU1341YheILcIRk1
3iSx0x1G/11fZU8xggNkMIIDYAIBATB2MGIxCzAJBgNVBAYTAlpBMSUwIwYDVQQKExxUaGF3
dGUgQ29uc3VsdGluZyAoUHR5KSBMdGQuMSwwKgYDVQQDEyNUaGF3dGUgUGVyc29uYWwgRnJl
ZW1haWwgSXNzdWluZyBDQQIQTrGgkxzJbnibsa3oUSMXezAJBgUrDgMCGgUAoIIBwzAYBgkq
hkiG9w0BCQMxCwYJKoZIhvcNAQcBMBwGCSqGSIb3DQEJBTEPFw0wNzAxMzExMTU0MTZaMCMG
CSqGSIb3DQEJBDEWBBSpyoeoGiJgKcSXaUCXThG/atemhzBSBgkqhkiG9w0BCQ8xRTBDMAoG
CCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIAgDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggq
hkiG9w0DAgIBKDCBhQYJKwYBBAGCNxAEMXgwdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMc
VGhhd3RlIENvbnN1bHRpbmcgKFB0eSkgTHRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFs
IEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6xoJMcyW54m7Gt6FEjF3swgYcGCyqGSIb3DQEJEAIL
MXigdjBiMQswCQYDVQQGEwJaQTElMCMGA1UEChMcVGhhd3RlIENvbnN1bHRpbmcgKFB0eSkg
THRkLjEsMCoGA1UEAxMjVGhhd3RlIFBlcnNvbmFsIEZyZWVtYWlsIElzc3VpbmcgQ0ECEE6x
oJMcyW54m7Gt6FEjF3swDQYJKoZIhvcNAQEBBQAEggEAU5YkmDqFRQZnMMKhCXqRJLbq5aob
kGByburyLJ+ujoZPvzSbFrx0ZFE9s/cAtqWnyyXH1uIP9d4hZInGsFOARYoJO7SmtnvCHrvE
zVOLjLnBXYd8/i1aQgAhygEs+/uPhZPQemrKJC2aRrHJ5OC431ZU3ZZDHuskZ7ELMtLx9Tv0
Qq8oZr0q5tw8IaZ5hSB0VJttc4gNfQCyUDeZe+H+rqg8rYmUjmyFYJnKIN/y7olAMPFWLVaU
FYGJoIxXR7k021WyCGvF4sMllJPy0gcBA3oJMh4rWQEweit4HcpXFAaxWvV8HXhxOljsUKhY
ET2DiUpOaJt90/oXSAIT0/Es0gAAAAAAAA==
--------------ms070304000904080406080109--

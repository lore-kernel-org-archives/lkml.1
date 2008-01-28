Return-Path: <linux-kernel-owner+w=401wt.eu-S1764549AbYA1XOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764549AbYA1XOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764220AbYA1XNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:25 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764300AbYA1XNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=tHc3ygSLanGv3RDKMcy+hgxBmg8uEslafDVgriwtzbnWtfQGfhB+OcHGhLoqRqtInbRHUJuH0NeI1usltARpQzCEVqFxEoYCtzNbneU+27TPmDZGJcj94+qZCOxbpP+c5asbiOr1OLketBrsK7FSem1CPWkAttmuQowLDR0sIVY=
Message-ID: <6101e8c40801281513n5106f8e2q4d68111967120f1@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:21 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {02/17} - invalid-semicolon - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "=?ISO-8859-1?Q?Ilpo_J=C3~C=C2=A4rvinen?=" 
	<ilpo.jarvinen@helsinki.fi>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8097_7740782.1201562001427"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8097_7740782.1201562001427
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8097_7740782.1201562001427
Content-Type: text/x-diff; name=invalid-semicolon
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=invalid-semicolon

Y29tbWl0IDliMzBiYWI2ZmRlMjgxY2Q2ZDE0M2MyMTQwYjkzZTc5MGM0MDVkYzcKQXV0aG9yOiBJ
bHBvIErDg8KkcnZpbmVuIDxpbHBvLmphcnZpbmVuQGhlbHNpbmtpLmZpPgpEYXRlOiAgIE1vbiBK
YW4gMjggMjA6NTQ6MTMgMjAwOCArMDEwMAoKICAgIFN1YmplY3Q6IFtQT1dFUlBDXSBGaXggaW52
YWxpZCBzZW1pY29sb24gYWZ0ZXIgaWYgc3RhdGVtZW50CiAgICBQYXRjaC1tYWlubGluZTogMi42
LjIzLXJjNCAyYjAyZDEzOTk2ZmUyODQ3OGU0NTYwNWRlOWJkOGJkY2EyNTcxOGRlCiAgICBBY2tl
ZC1ieTogc2Nod2FiQHN1c2UuZGUKICAgIAogICAgICAgIEEgc2ltaWxhciBmaXggdG8gbmV0Zmls
dGVyIGZyb20gRXJpYyBEdW1hemV0IGluc3BpcmVkIG1lIHRvCiAgICAgICAgbG9vayBhcm91bmQg
YSBiaXQgYnkgdXNpbmcgc29tZSBncmVwL3NlZCBzdHVmZiBhcyBsb29raW5nIGZvcgogICAgICAg
IHRoaXMga2luZCBvZiBidWdzIHNlZW1lZCBlYXN5IHRvIGF1dG9tYXRlLiAgVGhpcyBpcyBvbmUg
b2YgdGhlbQogICAgICAgIEkgZm91bmQgd2hlcmUgaXQgbG9va3MgbGlrZSB0aGlzIHNlbWljb2xv
biBpcyBub3QgdmFsaWQuCiAgICAKICAgICAgICBTaWduZWQtb2ZmLWJ5OiBJbHBvIErDg8KkcnZp
bmVuIDxpbHBvLmphcnZpbmVuQGhlbHNpbmtpLmZpPgogICAgICAgIEFja2VkLWJ5OiBCZW5qYW1p
biBIZXJyZW5zY2htaWR0IDxiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmc+CiAgICAgICAgU2lnbmVk
LW9mZi1ieTogUGF1bCBNYWNrZXJyYXMgPHBhdWx1c0BzYW1iYS5vcmc+CgpkaWZmIC0tZ2l0IGEv
YXJjaC9wb3dlcnBjL21tL2hhc2hfdXRpbHNfNjQuYyBiL2FyY2gvcG93ZXJwYy9tbS9oYXNoX3V0
aWxzXzY0LmMKaW5kZXggNGYyZjQ1My4uYzg0YjdjYyAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBj
L21tL2hhc2hfdXRpbHNfNjQuYworKysgYi9hcmNoL3Bvd2VycGMvbW0vaGFzaF91dGlsc182NC5j
CkBAIC03OTUsNyArNzk1LDcgQEAgdm9pZCBoYXNoX3ByZWxvYWQoc3RydWN0IG1tX3N0cnVjdCAq
bW0sIHVuc2lnbmVkIGxvbmcgZWEsCiAKICNpZmRlZiBDT05GSUdfUFBDX01NX1NMSUNFUwogCS8q
IFdlIG9ubHkgcHJlZmF1bHQgc3RhbmRhcmQgcGFnZXMgZm9yIG5vdyAqLwotCWlmICh1bmxpa2Vs
eShnZXRfc2xpY2VfcHNpemUobW0sIGVhKSAhPSBtbS0+Y29udGV4dC51c2VyX3BzaXplKSk7CisJ
aWYgKHVubGlrZWx5KGdldF9zbGljZV9wc2l6ZShtbSwgZWEpICE9IG1tLT5jb250ZXh0LnVzZXJf
cHNpemUpKQogCQlyZXR1cm47CiAjZW5kaWYKIAo=
------=_Part_8097_7740782.1201562001427--

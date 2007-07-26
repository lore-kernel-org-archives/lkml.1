Return-Path: <linux-kernel-owner+w=401wt.eu-S935317AbXGZSzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317AbXGZSzr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933995AbXGZSzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:55:05 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:32433 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933852AbXGZSzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:55:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=YqJRew9BWAL71nThVIiCfHsnCkVJ1ELSgyxsFKe2zB4z6/oboSrBA2LaSpr8z6uJ7U6vvihmwvVaB+2uk/75v3hZLqnevtzVTq9EOO3WSJe9wovdWbpr1q6uq48inU0iO4jkWuFNXDsyKpkR7crb2v4E0/+ziHVZZzrFtU1VHF4=
Message-ID: <6101e8c40707261155l188d484bjb65663509a7295c3@mail.gmail.com>
Date: Thu, 26 Jul 2007 20:55:00 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: [GIT PATCH 01/02] add cpu codenames for Kconfig.cpu (i386, x86_64)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_200305_14809870.1185476100304"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_200305_14809870.1185476100304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

commit 3393c5c744b1d18e73776c6e20f3676c9f2c07eb
Author: oliver <oliver@pancs.(none)>
Date:   Thu Jul 26 20:33:47 2007 +0200

    add cpu core name for arch/i386/Kconfig.cpu:Pentium 4 sections help
    add Pentium D for arch/i386/Kconfig.cpu
    add Pentium D for arch/x86_64/Kconfig

    Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

 arch/i386/Kconfig.cpu |   34 +++++++++++++++++++++++++++++++---
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 34 insertions(+), 6 deletions(-)

-- 
Thanks,
Oliver

------=_Part_200305_14809870.1185476100304
Content-Type: text/x-diff; name=01_add_cpu_names_to_kconfig_cpu.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename="01_add_cpu_names_to_kconfig_cpu.patch"

Y29tbWl0IDMzOTNjNWM3NDRiMWQxOGU3Mzc3NmM2ZTIwZjM2NzZjOWYyYzA3ZWIKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgVGh1IEp1bCAyNiAy
MDozMzo0NyAyMDA3ICswMjAwCgogICAgYWRkIGNwdSBjb3JlIG5hbWUgZm9yIGFyY2gvaTM4Ni9L
Y29uZmlnLmNwdTpQZW50aXVtIDQgc2VjdGlvbnMgaGVscAogICAgYWRkIFBlbnRpdW0gRCBmb3Ig
YXJjaC9pMzg2L0tjb25maWcuY3B1CiAgICBhZGQgUGVudGl1bSBEIGZvciBhcmNoL3g4Nl82NC9L
Y29uZmlnCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IE9saXZlciBQaW50ZXIgPG9saXZlci5wbnRy
QGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL2kzODYvS2NvbmZpZy5jcHUgYi9hcmNoL2kz
ODYvS2NvbmZpZy5jcHUKaW5kZXggMTFhMjRkNS4uYWY3MDFiMyAxMDA2NDQKLS0tIGEvYXJjaC9p
Mzg2L0tjb25maWcuY3B1CisrKyBiL2FyY2gvaTM4Ni9LY29uZmlnLmNwdQpAQCAtMTE1LDExICsx
MTUsMzkgQEAgY29uZmlnIE1QRU5USVVNNAogCWJvb2wgIlBlbnRpdW0tNC9DZWxlcm9uKFA0LWJh
c2VkKS9QZW50aXVtLTQgTS9vbGRlciBYZW9uIgogCWhlbHAKIAkgIFNlbGVjdCB0aGlzIGZvciBJ
bnRlbCBQZW50aXVtIDQgY2hpcHMuICBUaGlzIGluY2x1ZGVzIHRoZQotCSAgUGVudGl1bSA0LCBQ
NC1iYXNlZCBDZWxlcm9uIGFuZCBYZW9uLCBhbmQgUGVudGl1bS00IE0KLQkgIChub3QgUGVudGl1
bSBNKSBjaGlwcy4gIFRoaXMgb3B0aW9uIGVuYWJsZXMgY29tcGlsZSBmbGFncwotCSAgb3B0aW1p
emVkIGZvciB0aGUgY2hpcCwgdXNlcyB0aGUgY29ycmVjdCBjYWNoZSBzaGlmdCwgYW5kCisJICBQ
ZW50aXVtIDQsIFBlbnRpdW0gRCwgUDQtYmFzZWQgQ2VsZXJvbiBhbmQgWGVvbiwgYW5kCisJICBQ
ZW50aXVtLTQgTSAobm90IFBlbnRpdW0gTSkgY2hpcHMuICBUaGlzIG9wdGlvbiBlbmFibGVzIGNv
bXBpbGUKKwkgIGZsYWdzIG9wdGltaXplZCBmb3IgdGhlIGNoaXAsIHVzZXMgdGhlIGNvcnJlY3Qg
Y2FjaGUgc2hpZnQsIGFuZAogCSAgYXBwbGllcyBhbnkgYXBwbGljYWJsZSBQZW50aXVtIElJSSBv
cHRpbWl6YXRpb25zLgogCisJICBDUFVJRHM6IEZbMC02XVsxLUFdIChpbiAvcHJvYy9jcHVpbmZv
IHNob3cgPSBjcHUgZmFtaWx5IDogMTUgKQorCisJICBTZWxlY3QgdGhpcyBmb3I6CisJICAgIFBl
bnRpdW1zIChQZW50aXVtIDQsIFBlbnRpdW0gRCwgQ2VsZXJvbiwgQ2VsZXJvbiBEKSBjb3JlbmFt
ZToKKwkJLVdpbGxhbWV0dGUKKwkJLU5vcnRod29vZAorCQktTW9iaWxlIFBlbnRpdW0gNAorCQkt
TW9iaWxlIFBlbnRpdW0gNCBNCisJCS1FeHRyZW1lIEVkaXRpb24gKEdhbGxhdGluKQorCQktUHJl
c2NvdHQKKwkJLVByZXNjb3R0IDJNCisJCS1DZWRhciBNaWxsCisJCS1QcmVzbGVyCisJCS1TbWl0
aGZpbGVkCisJICAgIFhlb25zIChJbnRlbCBYZW9uLCBYZW9uIE1QLCBYZW9uIExWLCBYZW9uIE1W
KSBjb3JlbmFtZToKKwkgICAgCS1Gb3N0ZXIKKwkJLVByZXN0b25pYQorCQktR2FsbGF0aW4KKwkJ
LU5vY29uYQorCQktSXJ3aW5kYWxlCisJCS1DcmFuZm9yZAorCQktUG90b21hYworCQktUGF4dmls
bGUKKwkJLURlbXBzZXkKKworCSAgbW9yZSBpbmZvOiBodHRwOi8vYmFsdXNjLnhzNGFsbC5ubC9z
cnYvaGFyLWNwdS5odG1sCisJCQorCiBjb25maWcgTUs2CiAJYm9vbCAiSzYvSzYtSUkvSzYtSUlJ
IgogCWhlbHAKZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L0tjb25maWcgYi9hcmNoL3g4Nl82NC9L
Y29uZmlnCmluZGV4IDQ1ZjgyYWUuLjQ3ODA3ZTUgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2XzY0L0tj
b25maWcKKysrIGIvYXJjaC94ODZfNjQvS2NvbmZpZwpAQCAtMTY5LDkgKzE2OSw5IEBAIGNvbmZp
ZyBNSzgKIGNvbmZpZyBNUFNDCiAgICAgICAgYm9vbCAiSW50ZWwgUDQgLyBvbGRlciBOZXRidXJz
dCBiYXNlZCBYZW9uIgogICAgICAgIGhlbHAKLQkgIE9wdGltaXplIGZvciBJbnRlbCBQZW50aXVt
IDQgYW5kIG9sZGVyIE5vY29uYS9EZW1wc2V5IFhlb24gQ1BVcwotCSAgd2l0aCBJbnRlbCBFeHRl
bmRlZCBNZW1vcnkgNjQgVGVjaG5vbG9neShFTTY0VCkuIEZvciBkZXRhaWxzIHNlZQotCSAgPGh0
dHA6Ly93d3cuaW50ZWwuY29tL3RlY2hub2xvZ3kvNjRiaXRleHRlbnNpb25zLz4uCisJICBPcHRp
bWl6ZSBmb3IgSW50ZWwgUGVudGl1bSA0LCBQZW50aXVtIEQgYW5kIG9sZGVyIE5vY29uYS9EZW1w
c2V5CisJICBYZW9uIENQVXMgd2l0aCBJbnRlbCBFeHRlbmRlZCBNZW1vcnkgNjQgVGVjaG5vbG9n
eShFTTY0VCkuIEZvcgorCSAgZGV0YWlscyBzZWUgPGh0dHA6Ly93d3cuaW50ZWwuY29tL3RlY2hu
b2xvZ3kvNjRiaXRleHRlbnNpb25zLz4uCiAJICBOb3RlIHRoYXQgdGhlIGxhdGVzdCBYZW9ucyAo
WGVvbiA1MXh4IGFuZCA1M3h4KSBhcmUgbm90IGJhc2VkIG9uIHRoZQogICAgICAgICAgIE5ldGJ1
cnN0IGNvcmUgYW5kIHNob3VsZG4ndCB1c2UgdGhpcyBvcHRpb24uIFlvdSBjYW4gZGlzdGluZ3Vp
c2ggdGhlbQogCSAgdXNpbmcgdGhlIGNwdSBmYW1pbHkgZmllbGQK
------=_Part_200305_14809870.1185476100304--

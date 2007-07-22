Return-Path: <linux-kernel-owner+w=401wt.eu-S933242AbXGVXls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933242AbXGVXls (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765531AbXGVXlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:41:06 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:2761 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933082AbXGVXlE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:41:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type;
        b=g+JSkuOo0cTdJMC4Vv9cayVYwcLoyqqH035nBZQ6oHQeidINcRUaj+NN4Ei5e6MTQ+FgaGFfvvLqyuHG1MBhDatAPj8b1/gMbMZGSxXKw724BR99av6/kIi9CluQl2giM8A/hG99rDPcPgEs/olBX8TU7trxF+T9y4WylfJJtkw=
Message-ID: <6101e8c40707221641lea33197y70a4cc9b5267b079@mail.gmail.com>
Date: Mon, 23 Jul 2007 01:41:03 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE][GIT PATCH 02/02 ] Kconfig.cpu cosmetics (resend)
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_148801_17302368.1185147663778"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_148801_17302368.1185147663778
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

02_change_cpu_order_in_Kconfig_cpu.patch:

 arch/i386/Kconfig.cpu |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

-- 
Thanks,
Oliver

------=_Part_148801_17302368.1185147663778
Content-Type: text/x-patch; name=02_change_cpu_order_in_Kconfig_cpu.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4g6ncpx
Content-Disposition: attachment; filename="02_change_cpu_order_in_Kconfig_cpu.patch"

Y29tbWl0IGNlZmM0NjdmMDM3ZTM3NGJlZWNiODI1MjI2Mjk0YmUwMTQxMjA1MDkKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEp1bCAyMyAw
MTowNjowNiAyMDA3ICswMjAwCgogICAgY2hhbmdlIENQVSBvcmRlciBpbiBLY29uZmlnLmNwdSBi
eSBwcm9kdWN0aW9uIHRpbWVzIGJ5IG1hbnVmYWN0dXJlciBhbmQgbW9kZWxscwoKICAgIFNpZ25l
ZC1vZmYtYnk6IE9saXZlciBQaW50ZXIgPG9saXZlci5wbnRyQGdtYWlsLmNvbT4KCmRpZmYgLS1n
aXQgYS9hcmNoL2kzODYvS2NvbmZpZy5jcHUgYi9hcmNoL2kzODYvS2NvbmZpZy5jcHUKaW5kZXgg
ZGNjOTY1Ny4uY2U5NWU1MCAxMDA2NDQKLS0tIGEvYXJjaC9pMzg2L0tjb25maWcuY3B1CisrKyBi
L2FyY2gvaTM4Ni9LY29uZmlnLmNwdQpAQCAtMTA0LDEzICsxMDQsNiBAQCBjb25maWcgTVBFTlRJ
VU1NCiAJICBTZWxlY3QgdGhpcyBmb3IgSW50ZWwgUGVudGl1bSBNIChub3QgUGVudGl1bS00IE0p
CiAJICBub3RlYm9vayBjaGlwcy4KIAotY29uZmlnIE1DT1JFMgotCWJvb2wgIkNvcmUgMi9uZXdl
ciBYZW9uIgotCWhlbHAKLQkgIFNlbGVjdCB0aGlzIGZvciBJbnRlbCBDb3JlIDIgYW5kIG5ld2Vy
IENvcmUgMiBYZW9ucyAoWGVvbiA1MXh4IGFuZCA1M3h4KQotCSAgQ1BVcy4gWW91IGNhbiBkaXN0
aW5ndWlzaCBuZXdlciBmcm9tIG9sZGVyIFhlb25zIGJ5IHRoZSBDUFUgZmFtaWx5Ci0JICBpbiAv
cHJvYy9jcHVpbmZvLiBOZXdlciBvbmVzIGhhdmUgNi4KLQogY29uZmlnIE1QRU5USVVNNAogCWJv
b2wgIlBlbnRpdW0tNC9DZWxlcm9uKFA0LWJhc2VkKS9QZW50aXVtLTQgTS9vbGRlciBYZW9uIgog
CWhlbHAKQEAgLTEyMCw2ICsxMTMsMTMgQEAgY29uZmlnIE1QRU5USVVNNAogCSAgZmxhZ3Mgb3B0
aW1pemVkIGZvciB0aGUgY2hpcCwgdXNlcyB0aGUgY29ycmVjdCBjYWNoZSBzaGlmdCwgYW5kCiAJ
ICBhcHBsaWVzIGFueSBhcHBsaWNhYmxlIFBlbnRpdW0gSUlJIG9wdGltaXphdGlvbnMuCiAKK2Nv
bmZpZyBNQ09SRTIKKwlib29sICJDb3JlIDIvbmV3ZXIgWGVvbiIKKwloZWxwCisJICBTZWxlY3Qg
dGhpcyBmb3IgSW50ZWwgQ29yZSAyIGFuZCBuZXdlciBDb3JlIDIgWGVvbnMgKFhlb24gNTF4eCBh
bmQgNTN4eCkKKwkgIENQVXMuIFlvdSBjYW4gZGlzdGluZ3Vpc2ggbmV3ZXIgZnJvbSBvbGRlciBY
ZW9ucyBieSB0aGUgQ1BVIGZhbWlseQorCSAgaW4gL3Byb2MvY3B1aW5mby4gTmV3ZXIgb25lcyBo
YXZlIDYuCisKIGNvbmZpZyBNSzYKIAlib29sICJLNi9LNi1JSS9LNi1JSUkiCiAJaGVscAo=
------=_Part_148801_17302368.1185147663778--

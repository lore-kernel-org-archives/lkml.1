Return-Path: <linux-kernel-owner+w=401wt.eu-S935827AbXGZS4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935827AbXGZS4M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 14:56:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764471AbXGZSzP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 14:55:15 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:20037 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764671AbXGZSzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 14:55:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=oLmRrtVk0RlBtFw4sl10gPcqo8QucuCQVa2/e09vQHqWYo30IvAHv6+AKN+7lO42OKrA4lmwkPbQEzJGye9PzJvc7OB5qJ554MG2YQxvJpE6EhOqD7ErKrDI+UyZvo8FhtovgkKgWAwi3GLkoM+ApKOoIK1gvUECenx8faxogmg=
Message-ID: <6101e8c40707261155x1a2b2a3fj31e26300a958224a@mail.gmail.com>
Date: Thu, 26 Jul 2007 20:55:12 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: [GIT PATCH 02/02] change order in Kconfig.cpu (i386)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_200309_24636388.1185476112194"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_200309_24636388.1185476112194
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

commit c2d2983585e8a46639ca95f6c6122807d8312547
Author: oliver <oliver@pancs.(none)>
Date:   Thu Jul 26 20:42:16 2007 +0200

    change the sort in arch/i386/Kconfig.cpu file, while it is logicaller (by pr
oductions time-line).

    Signed-off-by: Oliver Pinter <oliver.pntr@gmail.com>

 arch/i386/Kconfig.cpu |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


-- 
Thanks,
Oliver

------=_Part_200309_24636388.1185476112194
Content-Type: text/x-diff; name=02_change_order_in_i386_Kconfig_cpu.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename="02_change_order_in_i386_Kconfig_cpu.patch"

Y29tbWl0IGMyZDI5ODM1ODVlOGE0NjYzOWNhOTVmNmM2MTIyODA3ZDgzMTI1NDcKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgVGh1IEp1bCAyNiAy
MDo0MjoxNiAyMDA3ICswMjAwCgogICAgY2hhbmdlIHRoZSBzb3J0IGluIGFyY2gvaTM4Ni9LY29u
ZmlnLmNwdSBmaWxlLCB3aGlsZSBpdCBpcyBsb2dpY2FsbGVyIChieSBwcm9kdWN0aW9ucyB0aW1l
LWxpbmUpLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBPbGl2ZXIgUGludGVyIDxvbGl2ZXIucG50
ckBnbWFpbC5jb20+CgpkaWZmIC0tZ2l0IGEvYXJjaC9pMzg2L0tjb25maWcuY3B1IGIvYXJjaC9p
Mzg2L0tjb25maWcuY3B1CmluZGV4IGFmNzAxYjMuLjgzMzFkNWUgMTAwNjQ0Ci0tLSBhL2FyY2gv
aTM4Ni9LY29uZmlnLmNwdQorKysgYi9hcmNoL2kzODYvS2NvbmZpZy5jcHUKQEAgLTEwNCwxMyAr
MTA0LDYgQEAgY29uZmlnIE1QRU5USVVNTQogCSAgU2VsZWN0IHRoaXMgZm9yIEludGVsIFBlbnRp
dW0gTSAobm90IFBlbnRpdW0tNCBNKQogCSAgbm90ZWJvb2sgY2hpcHMuCiAKLWNvbmZpZyBNQ09S
RTIKLQlib29sICJDb3JlIDIvbmV3ZXIgWGVvbiIKLQloZWxwCi0JICBTZWxlY3QgdGhpcyBmb3Ig
SW50ZWwgQ29yZSAyIGFuZCBuZXdlciBDb3JlIDIgWGVvbnMgKFhlb24gNTF4eCBhbmQgNTN4eCkK
LQkgIENQVXMuIFlvdSBjYW4gZGlzdGluZ3Vpc2ggbmV3ZXIgZnJvbSBvbGRlciBYZW9ucyBieSB0
aGUgQ1BVIGZhbWlseQotCSAgaW4gL3Byb2MvY3B1aW5mby4gTmV3ZXIgb25lcyBoYXZlIDYuCi0K
IGNvbmZpZyBNUEVOVElVTTQKIAlib29sICJQZW50aXVtLTQvQ2VsZXJvbihQNC1iYXNlZCkvUGVu
dGl1bS00IE0vb2xkZXIgWGVvbiIKIAloZWxwCkBAIC0xNDcsNiArMTQwLDEyIEBAIGNvbmZpZyBN
UEVOVElVTTQKIAogCSAgbW9yZSBpbmZvOiBodHRwOi8vYmFsdXNjLnhzNGFsbC5ubC9zcnYvaGFy
LWNwdS5odG1sCiAJCQorY29uZmlnIE1DT1JFMgorCWJvb2wgIkNvcmUgMi9uZXdlciBYZW9uIgor
CWhlbHAKKwkgIFNlbGVjdCB0aGlzIGZvciBJbnRlbCBDb3JlIDIgYW5kIG5ld2VyIENvcmUgMiBY
ZW9ucyAoWGVvbiA1MXh4IGFuZCA1M3h4KQorCSAgQ1BVcy4gWW91IGNhbiBkaXN0aW5ndWlzaCBu
ZXdlciBmcm9tIG9sZGVyIFhlb25zIGJ5IHRoZSBDUFUgZmFtaWx5CisJICBpbiAvcHJvYy9jcHVp
bmZvLiBOZXdlciBvbmVzIGhhdmUgNi4KIAogY29uZmlnIE1LNgogCWJvb2wgIks2L0s2LUlJL0s2
LUlJSSIK
------=_Part_200309_24636388.1185476112194--

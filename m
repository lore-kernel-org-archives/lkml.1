Return-Path: <linux-kernel-owner+w=401wt.eu-S1764330AbXGVUQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764330AbXGVUQZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 16:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761902AbXGVUQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 16:16:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:1681 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760632AbXGVUQS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 16:16:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:references;
        b=qOtxTaZIyOJd6SzvC0t50NeCHxZ9cCkO9apiFs9YBLXOGOA4Vlvz7+aLIvy3NO4D28u/gsZTQggQxH+4C8WsKW/X2pXwJxBmre0cCwHR2ERmAnYwP/HgAWk4gvi+QYaTKTXajweM13XDbd9wsiKaR2dyateeGkSrNa84R56IeR4=
Message-ID: <6101e8c40707221316t744c7c15pc7ed8f179e0bab25@mail.gmail.com>
Date: Sun, 22 Jul 2007 22:16:14 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Fwd: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
In-Reply-To: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_147772_24973450.1185135374596"
References: <6101e8c40707221311l19a7e39r36b99bcb2dcaaae1@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_147772_24973450.1185135374596
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

---------- Forwarded message ----------
From: Oliver Pinter <oliver.pntr@gmail.com>
Date: Jul 22, 2007 10:11 PM
Subject: [ANNOUNCE][GIT PATCH] Kconfig.cpu cosmetics
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: zippel@linux-m68k.org, sam@ravnborg.org


Hi all!

Here is one patch, Kconfig.cpu, this patch add the Pentium D processor
for help, because number of person has the question: I have Pentium D,
and which CPU chose  I.

 arch/i386/Kconfig.cpu |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

Thanks
Oliver

------=_Part_147772_24973450.1185135374596
Content-Type: text/x-patch; name=kconfig_cpu_cosmetic.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4fyxsll
Content-Disposition: attachment; filename="kconfig_cpu_cosmetic.patch"

Y29tbWl0IDBjZmM3ZWVlMmRmZTA4ZGMwYzYwOWI1N2VkN2JlNTQ4ODZiZDhmMGIKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgU3VuIEp1bCAyMiAy
MTo1OToyNyAyMDA3ICswMjAwCgogICAgS2NvbmZpZy5jcHUgY29zbWV0aWNzCiAgICAKICAgIAlB
ZGQgUGVudGl1bSBEIGZvciBQZW50aXVtIDQgaGVscAoJQ2hhbmdlIHRoZSBzb3J0IGJ5IHRpbWVs
aW5lIGluIGNwdS10eXBlcwoKCVNpZ25lZC1vZmYtYnk6IE9saXZlciBQaW50ZXIgPG9saXZlci5w
bnRyQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9hcmNoL2kzODYvS2NvbmZpZy5jcHUgYi9hcmNo
L2kzODYvS2NvbmZpZy5jcHUKaW5kZXggMTFhMjRkNS4uY2U5NWU1MCAxMDA2NDQKLS0tIGEvYXJj
aC9pMzg2L0tjb25maWcuY3B1CisrKyBiL2FyY2gvaTM4Ni9LY29uZmlnLmNwdQpAQCAtMTA0LDYg
KzEwNCwxNSBAQCBjb25maWcgTVBFTlRJVU1NCiAJICBTZWxlY3QgdGhpcyBmb3IgSW50ZWwgUGVu
dGl1bSBNIChub3QgUGVudGl1bS00IE0pCiAJICBub3RlYm9vayBjaGlwcy4KIAorY29uZmlnIE1Q
RU5USVVNNAorCWJvb2wgIlBlbnRpdW0tNC9DZWxlcm9uKFA0LWJhc2VkKS9QZW50aXVtLTQgTS9v
bGRlciBYZW9uIgorCWhlbHAKKwkgIFNlbGVjdCB0aGlzIGZvciBJbnRlbCBQZW50aXVtIDQgY2hp
cHMuICBUaGlzIGluY2x1ZGVzIHRoZQorCSAgUGVudGl1bSA0LCBQZW50aXVtIEQsIFA0LWJhc2Vk
IENlbGVyb24gYW5kIFhlb24sIGFuZAorCSAgUGVudGl1bS00IE0gKG5vdCBQZW50aXVtIE0pIGNo
aXBzLiAgVGhpcyBvcHRpb24gZW5hYmxlcyBjb21waWxlCisJICBmbGFncyBvcHRpbWl6ZWQgZm9y
IHRoZSBjaGlwLCB1c2VzIHRoZSBjb3JyZWN0IGNhY2hlIHNoaWZ0LCBhbmQKKwkgIGFwcGxpZXMg
YW55IGFwcGxpY2FibGUgUGVudGl1bSBJSUkgb3B0aW1pemF0aW9ucy4KKwogY29uZmlnIE1DT1JF
MgogCWJvb2wgIkNvcmUgMi9uZXdlciBYZW9uIgogCWhlbHAKQEAgLTExMSwxNSArMTIwLDYgQEAg
Y29uZmlnIE1DT1JFMgogCSAgQ1BVcy4gWW91IGNhbiBkaXN0aW5ndWlzaCBuZXdlciBmcm9tIG9s
ZGVyIFhlb25zIGJ5IHRoZSBDUFUgZmFtaWx5CiAJICBpbiAvcHJvYy9jcHVpbmZvLiBOZXdlciBv
bmVzIGhhdmUgNi4KIAotY29uZmlnIE1QRU5USVVNNAotCWJvb2wgIlBlbnRpdW0tNC9DZWxlcm9u
KFA0LWJhc2VkKS9QZW50aXVtLTQgTS9vbGRlciBYZW9uIgotCWhlbHAKLQkgIFNlbGVjdCB0aGlz
IGZvciBJbnRlbCBQZW50aXVtIDQgY2hpcHMuICBUaGlzIGluY2x1ZGVzIHRoZQotCSAgUGVudGl1
bSA0LCBQNC1iYXNlZCBDZWxlcm9uIGFuZCBYZW9uLCBhbmQgUGVudGl1bS00IE0KLQkgIChub3Qg
UGVudGl1bSBNKSBjaGlwcy4gIFRoaXMgb3B0aW9uIGVuYWJsZXMgY29tcGlsZSBmbGFncwotCSAg
b3B0aW1pemVkIGZvciB0aGUgY2hpcCwgdXNlcyB0aGUgY29ycmVjdCBjYWNoZSBzaGlmdCwgYW5k
Ci0JICBhcHBsaWVzIGFueSBhcHBsaWNhYmxlIFBlbnRpdW0gSUlJIG9wdGltaXphdGlvbnMuCi0K
IGNvbmZpZyBNSzYKIAlib29sICJLNi9LNi1JSS9LNi1JSUkiCiAJaGVscAo=
------=_Part_147772_24973450.1185135374596--

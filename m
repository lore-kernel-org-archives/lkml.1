Return-Path: <linux-kernel-owner+w=401wt.eu-S933170AbXGVXlY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933170AbXGVXlY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 19:41:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933068AbXGVXlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 19:41:00 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:2761 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933015AbXGVXk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 19:40:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=irJ2kgJ95Uh+RCJAOlgqz+8MruAfndCZ8en/ZFGWEwsna7T8JU4qzXDgS7s0SfPcjgtx+jyaJXz4OTdU/dGMKk5bIV93fJIC/CahIxtEfXNoZ7OLaPKhtlptJxCX3vIF8vZAGkMD/dqhPDOdJn2G8abYETxTwZiLS7+s7ZylHm4=
Message-ID: <6101e8c40707221640y66fc4f8av8e542585101c0fe5@mail.gmail.com>
Date: Mon, 23 Jul 2007 01:40:56 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [ANNOUNCE][GIT PATCH 01/02 ] Kconfig.cpu cosmetics (resend)
Cc: "Andi Kleen" <andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_148797_16887997.1185147656632"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_148797_16887997.1185147656632
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

01_add_pentium_d_for_kconfig_cpu.patch:

arch/i386/Kconfig.cpu |    6 +++---
 arch/x86_64/Kconfig   |    6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)


-- 
Thanks,
Oliver

------=_Part_148797_16887997.1185147656632
Content-Type: text/x-patch; name=01_add_pentium_d_for_kconfig_cpu.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f4g6dlzt
Content-Disposition: attachment; filename="01_add_pentium_d_for_kconfig_cpu.patch"

Y29tbWl0IDU2YzdiYjUwNDIwMDg2OTg3NTJiN2ViNmFiYjhhMjgyNTY4Njc5NDEKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEp1bCAyMyAw
MDo0Nzo0NyAyMDA3ICswMjAwCgogICAgYWRkIFBlbnRpdW0gRCBmb3IgS2NvbmZpZy5jcHUsIGJl
Y2F1c2Ugc29tZSBwZW9wbGUgZG9uJ3Qga25vdywgd2hpY2ggY3B1IGNob3NlIGZvciBQZW50aXVt
IEQuCgogICAgU2lnbmVkLW9mZi1ieTogT2xpdmVyIFBpbnRlciA8b2xpdmVyLnBudHJAZ21haWwu
Y29tPgoKZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9LY29uZmlnLmNwdSBiL2FyY2gvaTM4Ni9LY29u
ZmlnLmNwdQppbmRleCAxMWEyNGQ1Li5kY2M5NjU3IDEwMDY0NAotLS0gYS9hcmNoL2kzODYvS2Nv
bmZpZy5jcHUKKysrIGIvYXJjaC9pMzg2L0tjb25maWcuY3B1CkBAIC0xMTUsOSArMTE1LDkgQEAg
Y29uZmlnIE1QRU5USVVNNAogCWJvb2wgIlBlbnRpdW0tNC9DZWxlcm9uKFA0LWJhc2VkKS9QZW50
aXVtLTQgTS9vbGRlciBYZW9uIgogCWhlbHAKIAkgIFNlbGVjdCB0aGlzIGZvciBJbnRlbCBQZW50
aXVtIDQgY2hpcHMuICBUaGlzIGluY2x1ZGVzIHRoZQotCSAgUGVudGl1bSA0LCBQNC1iYXNlZCBD
ZWxlcm9uIGFuZCBYZW9uLCBhbmQgUGVudGl1bS00IE0KLQkgIChub3QgUGVudGl1bSBNKSBjaGlw
cy4gIFRoaXMgb3B0aW9uIGVuYWJsZXMgY29tcGlsZSBmbGFncwotCSAgb3B0aW1pemVkIGZvciB0
aGUgY2hpcCwgdXNlcyB0aGUgY29ycmVjdCBjYWNoZSBzaGlmdCwgYW5kCisJICBQZW50aXVtIDQs
IFBlbnRpdW0gRCwgUDQtYmFzZWQgQ2VsZXJvbiBhbmQgWGVvbiwgYW5kCisJICBQZW50aXVtLTQg
TSAobm90IFBlbnRpdW0gTSkgY2hpcHMuICBUaGlzIG9wdGlvbiBlbmFibGVzIGNvbXBpbGUKKwkg
IGZsYWdzIG9wdGltaXplZCBmb3IgdGhlIGNoaXAsIHVzZXMgdGhlIGNvcnJlY3QgY2FjaGUgc2hp
ZnQsIGFuZAogCSAgYXBwbGllcyBhbnkgYXBwbGljYWJsZSBQZW50aXVtIElJSSBvcHRpbWl6YXRp
b25zLgogCiBjb25maWcgTUs2CmRpZmYgLS1naXQgYS9hcmNoL3g4Nl82NC9LY29uZmlnIGIvYXJj
aC94ODZfNjQvS2NvbmZpZwppbmRleCA0NWY4MmFlLi40NzgwN2U1IDEwMDY0NAotLS0gYS9hcmNo
L3g4Nl82NC9LY29uZmlnCisrKyBiL2FyY2gveDg2XzY0L0tjb25maWcKQEAgLTE2OSw5ICsxNjks
OSBAQCBjb25maWcgTUs4CiBjb25maWcgTVBTQwogICAgICAgIGJvb2wgIkludGVsIFA0IC8gb2xk
ZXIgTmV0YnVyc3QgYmFzZWQgWGVvbiIKICAgICAgICBoZWxwCi0JICBPcHRpbWl6ZSBmb3IgSW50
ZWwgUGVudGl1bSA0IGFuZCBvbGRlciBOb2NvbmEvRGVtcHNleSBYZW9uIENQVXMKLQkgIHdpdGgg
SW50ZWwgRXh0ZW5kZWQgTWVtb3J5IDY0IFRlY2hub2xvZ3koRU02NFQpLiBGb3IgZGV0YWlscyBz
ZWUKLQkgIDxodHRwOi8vd3d3LmludGVsLmNvbS90ZWNobm9sb2d5LzY0Yml0ZXh0ZW5zaW9ucy8+
LgorCSAgT3B0aW1pemUgZm9yIEludGVsIFBlbnRpdW0gNCwgUGVudGl1bSBEIGFuZCBvbGRlciBO
b2NvbmEvRGVtcHNleQorCSAgWGVvbiBDUFVzIHdpdGggSW50ZWwgRXh0ZW5kZWQgTWVtb3J5IDY0
IFRlY2hub2xvZ3koRU02NFQpLiBGb3IKKwkgIGRldGFpbHMgc2VlIDxodHRwOi8vd3d3LmludGVs
LmNvbS90ZWNobm9sb2d5LzY0Yml0ZXh0ZW5zaW9ucy8+LgogCSAgTm90ZSB0aGF0IHRoZSBsYXRl
c3QgWGVvbnMgKFhlb24gNTF4eCBhbmQgNTN4eCkgYXJlIG5vdCBiYXNlZCBvbiB0aGUKICAgICAg
ICAgICBOZXRidXJzdCBjb3JlIGFuZCBzaG91bGRuJ3QgdXNlIHRoaXMgb3B0aW9uLiBZb3UgY2Fu
IGRpc3Rpbmd1aXNoIHRoZW0KIAkgIHVzaW5nIHRoZSBjcHUgZmFtaWx5IGZpZWxkCg==
------=_Part_148797_16887997.1185147656632--

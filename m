Return-Path: <linux-kernel-owner+w=401wt.eu-S1764852AbYA1XRG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764852AbYA1XRG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:17:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764338AbYA1XNo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:44 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764324AbYA1XNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=ijJflOGFlwA1n2pe6TTWF7E2adS0pldDIW2cXpbpS92lsbpI4o60/VkeRGYuB+yhLnBnljPNCeKrPd7yAgteYbXmPIxO+5rADoD1tAEHCpePSYnGxeC30FLscMYARpOkn844s/BKsLEi6KCkvtJINsU6VB1rogk2pOc/GA9u1e8=
Message-ID: <6101e8c40801281513j7a08e471ifb85d051d96ab395@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:41 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {07/17} - i386-fixup-TRACE_IRQ-breakage - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Jeff Mahoney" <jeffm@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8108_6270771.1201562021792"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8108_6270771.1201562021792
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8108_6270771.1201562021792
Content-Type: text/x-diff; name=i386-fixup-TRACE_IRQ-breakage
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=i386-fixup-TRACE_IRQ-breakage

Y29tbWl0IDg0N2Y1MWNiOGEwOWU2NDRiNzQ1MmIzOTZkOTgxZDU4ZGJiN2VlY2MKQXV0aG9yOiBQ
ZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkRhdGU6ICAgV2VkIEp1bCAxOCAx
ODo1OToyMiAyMDA3ICswMjAwCgogICAgU3ViamVjdDogaTM4NjogZml4dXAgVFJBQ0VfSVJRIGJy
ZWFrYWdlCiAgICBQYXRjaC1tYWlubGluZTogMi42LjIzLXJjMQogICAgUmVmZXJlbmNlczogMzI2
MjcwLCBDVkUtMjAwNy0zNzMxCiAgICAKICAgIGkzODY6IGZpeHVwIFRSQUNFX0lSUSBicmVha2Fn
ZQogICAgCiAgICBUaGUgVFJBQ0VfSVJRU19PTiBmdW5jdGlvbiBpbiBpcmV0X2V4YzogY2FsbHMg
YSBDIGZ1bmN0aW9uIHdpdGhvdXQKICAgIGVuc3VyaW5nIHRoYXQgdGhlIHNlZ21lbnRzIGFyZSBz
ZXQgcHJvcGVybHkuIE1vdmUgdGhlIHRyYWNlIGZ1bmN0aW9uIGFuZAogICAgdGhlIGVuYWJsaW5n
IG9mIGludGVycnVwdCBpbnRvIHRoZSBDIHN0dWIuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IFBl
dGVyIFppamxzdHJhIDxhLnAuemlqbHN0cmFAY2hlbGxvLm5sPgogICAgU2lnbmVkLW9mZi1ieTog
TGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgogICAgQWNrZWQt
Ynk6IEplZmYgTWFob25leSA8amVmZm1Ac3VzZS5jb20+CgpkaWZmIC0tZ2l0IGEvYXJjaC9pMzg2
L2tlcm5lbC9lbnRyeS5TIGIvYXJjaC9pMzg2L2tlcm5lbC9lbnRyeS5TCmluZGV4IDNjM2MyMjAu
LmI3YmU1Y2YgMTAwNjQ0Ci0tLSBhL2FyY2gvaTM4Ni9rZXJuZWwvZW50cnkuUworKysgYi9hcmNo
L2kzODYva2VybmVsL2VudHJ5LlMKQEAgLTQwOSw4ICs0MDksNiBAQCByZXN0b3JlX25vY2hlY2tf
bm90cmFjZToKIDE6CUlOVEVSUlVQVF9SRVRVUk4KIC5zZWN0aW9uIC5maXh1cCwiYXgiCiBpcmV0
X2V4YzoKLQlUUkFDRV9JUlFTX09OCi0JRU5BQkxFX0lOVEVSUlVQVFMoQ0xCUl9OT05FKQogCXB1
c2hsICQwCQkJIyBubyBlcnJvciBjb2RlCiAJcHVzaGwgJGRvX2lyZXRfZXJyb3IKIAlqbXAgZXJy
b3JfY29kZQpkaWZmIC0tZ2l0IGEvYXJjaC9pMzg2L2tlcm5lbC90cmFwcy5jIGIvYXJjaC9pMzg2
L2tlcm5lbC90cmFwcy5jCmluZGV4IDkwZGEwNTcuLjQ5OTViOTIgMTAwNjQ0Ci0tLSBhL2FyY2gv
aTM4Ni9rZXJuZWwvdHJhcHMuYworKysgYi9hcmNoL2kzODYva2VybmVsL3RyYXBzLmMKQEAgLTUx
NywxMCArNTE3LDEyIEBAIGZhc3RjYWxsIHZvaWQgZG9fIyNuYW1lKHN0cnVjdCBwdF9yZWdzICog
cmVncywgbG9uZyBlcnJvcl9jb2RlKSBcCiAJZG9fdHJhcCh0cmFwbnIsIHNpZ25yLCBzdHIsIDAs
IHJlZ3MsIGVycm9yX2NvZGUsIE5VTEwpOyBcCiB9CiAKLSNkZWZpbmUgRE9fRVJST1JfSU5GTyh0
cmFwbnIsIHNpZ25yLCBzdHIsIG5hbWUsIHNpY29kZSwgc2lhZGRyKSBcCisjZGVmaW5lIERPX0VS
Uk9SX0lORk8odHJhcG5yLCBzaWduciwgc3RyLCBuYW1lLCBzaWNvZGUsIHNpYWRkciwgaXJxKSBc
CiBmYXN0Y2FsbCB2b2lkIGRvXyMjbmFtZShzdHJ1Y3QgcHRfcmVncyAqIHJlZ3MsIGxvbmcgZXJy
b3JfY29kZSkgXAogeyBcCiAJc2lnaW5mb190IGluZm87IFwKKwlpZiAoaXJxKSBcCisJCWxvY2Fs
X2lycV9lbmFibGUoKTsgXAogCWluZm8uc2lfc2lnbm8gPSBzaWducjsgXAogCWluZm8uc2lfZXJy
bm8gPSAwOyBcCiAJaW5mby5zaV9jb2RlID0gc2ljb2RlOyBcCkBAIC01NjAsMTMgKzU2MiwxMyBA
QCBET19WTTg2X0VSUk9SKCAzLCBTSUdUUkFQLCAiaW50MyIsIGludDMpCiAjZW5kaWYKIERPX1ZN
ODZfRVJST1IoIDQsIFNJR1NFR1YsICJvdmVyZmxvdyIsIG92ZXJmbG93KQogRE9fVk04Nl9FUlJP
UiggNSwgU0lHU0VHViwgImJvdW5kcyIsIGJvdW5kcykKLURPX0VSUk9SX0lORk8oIDYsIFNJR0lM
TCwgICJpbnZhbGlkIG9wY29kZSIsIGludmFsaWRfb3AsIElMTF9JTExPUE4sIHJlZ3MtPmVpcCkK
K0RPX0VSUk9SX0lORk8oIDYsIFNJR0lMTCwgICJpbnZhbGlkIG9wY29kZSIsIGludmFsaWRfb3As
IElMTF9JTExPUE4sIHJlZ3MtPmVpcCwgMCkKIERPX0VSUk9SKCA5LCBTSUdGUEUsICAiY29wcm9j
ZXNzb3Igc2VnbWVudCBvdmVycnVuIiwgY29wcm9jZXNzb3Jfc2VnbWVudF9vdmVycnVuKQogRE9f
RVJST1IoMTAsIFNJR1NFR1YsICJpbnZhbGlkIFRTUyIsIGludmFsaWRfVFNTKQogRE9fRVJST1Io
MTEsIFNJR0JVUywgICJzZWdtZW50IG5vdCBwcmVzZW50Iiwgc2VnbWVudF9ub3RfcHJlc2VudCkK
IERPX0VSUk9SKDEyLCBTSUdCVVMsICAic3RhY2sgc2VnbWVudCIsIHN0YWNrX3NlZ21lbnQpCi1E
T19FUlJPUl9JTkZPKDE3LCBTSUdCVVMsICJhbGlnbm1lbnQgY2hlY2siLCBhbGlnbm1lbnRfY2hl
Y2ssIEJVU19BRFJBTE4sIDApCi1ET19FUlJPUl9JTkZPKDMyLCBTSUdTRUdWLCAiaXJldCBleGNl
cHRpb24iLCBpcmV0X2Vycm9yLCBJTExfQkFEU1RLLCAwKQorRE9fRVJST1JfSU5GTygxNywgU0lH
QlVTLCAiYWxpZ25tZW50IGNoZWNrIiwgYWxpZ25tZW50X2NoZWNrLCBCVVNfQURSQUxOLCAwLCAw
KQorRE9fRVJST1JfSU5GTygzMiwgU0lHU0VHViwgImlyZXQgZXhjZXB0aW9uIiwgaXJldF9lcnJv
ciwgSUxMX0JBRFNUSywgMCwgMSkKIAogZmFzdGNhbGwgdm9pZCBfX2twcm9iZXMgZG9fZ2VuZXJh
bF9wcm90ZWN0aW9uKHN0cnVjdCBwdF9yZWdzICogcmVncywKIAkJCQkJICAgICAgbG9uZyBlcnJv
cl9jb2RlKQo=
------=_Part_8108_6270771.1201562021792--

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbYEGQok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbYEGQok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 12:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751183AbYEGQo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 12:44:28 -0400
Received: from mu-out-0910.google.com ([209.85.134.187]:4466 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbYEGQoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 12:44:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=ZPhWJ0narPLwLOLHQt0OtvrIkKM6F4Zk2POrSrhXjQI67jWg4wHz7e4G1jF6GCcpmldYPWzyNOdc4tJjf7G1V3q0ZhWcfZuCE+VQWwrykjLxq+jqlLcjwm4UYjhi6GNH1t/TLeOT+iGoFD7ZmDPG6Wk3Lp/Ver9vOACcuxUYf7w=
Message-ID: <6101e8c40805070944m35c412f0q3cdf6df039b7f2ea@mail.gmail.com>
Date: Wed, 7 May 2008 18:44:23 +0200
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [OP] v2.6.22.24-op1-rc1
Cc: "Li Zefan" <lizf@cn.fujitsu.com>, "Zhao Yakui" <yakui.zhao@intel.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Len Brown" <len.brown@intel.com>, "Al Viro" <viro@zeniv.linux.org.uk>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16292_16366960.1210178663282"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16292_16366960.1210178663282
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

linux v2.6.22.21-op1-rc2
  "stable" review patch

---

 http://repo.or.cz/w/linux-2.6.22.y-op.git rc
 http://repo.or.cz/w/linux-2.6.22.y-op-patches.git

---

Al Viro (1):
      Fix dnotify/close race

Li Zefan (1):
      ACPI: check a return value correctly in acpi_power_get_context()

Oliver Pinter (1):
      v2.6.22.24-op1-rc1


---

 Makefile             |    2 +-
 drivers/acpi/power.c |    2 +-
 fs/dnotify.c         |   11 +++++++++++
 3 files changed, 13 insertions(+), 2 deletions(-)

-- 
Thanks,
Oliver

---

------=_Part_16292_16366960.1210178663282
Content-Type: text/x-diff; name=patch-v2.6.22.23-op1-v2.6.22.24-op1-rc1
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=patch-v2.6.22.23-op1-v2.6.22.24-op1-rc1

ZGlmZiAtLWdpdCBhL01ha2VmaWxlIGIvTWFrZWZpbGUKaW5kZXggZDAwMTk1OS4uNDkzYzk3MyAx
MDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTEsNyArMSw3IEBACiBWRVJT
SU9OID0gMgogUEFUQ0hMRVZFTCA9IDYKIFNVQkxFVkVMID0gMjIKLUVYVFJBVkVSU0lPTiA9IC4y
My1vcDEKK0VYVFJBVkVSU0lPTiA9IC4yNC1vcDEtcmMxCiBOQU1FID0gSG9seSBEYW5jaW5nIE1h
bmF0ZWVzLCBCYXRtYW4hCiAKICMgKkRPQ1VNRU5UQVRJT04qCmRpZmYgLS1naXQgYS9kcml2ZXJz
L2FjcGkvcG93ZXIuYyBiL2RyaXZlcnMvYWNwaS9wb3dlci5jCmluZGV4IDRmZmVjZDEuLmQyOTVl
ZDEgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYWNwaS9wb3dlci5jCisrKyBiL2RyaXZlcnMvYWNwaS9w
b3dlci5jCkBAIC0xMTYsNyArMTE2LDcgQEAgYWNwaV9wb3dlcl9nZXRfY29udGV4dChhY3BpX2hh
bmRsZSBoYW5kbGUsCiAJfQogCiAJKnJlc291cmNlID0gYWNwaV9kcml2ZXJfZGF0YShkZXZpY2Up
OwotCWlmICghcmVzb3VyY2UpCisJaWYgKCEqcmVzb3VyY2UpCiAJCXJldHVybiAtRU5PREVWOwog
CiAJcmV0dXJuIDA7CmRpZmYgLS1naXQgYS9mcy9kbm90aWZ5LmMgYi9mcy9kbm90aWZ5LmMKaW5k
ZXggOTM2NDA5Zi4uOTFiOTc1MyAxMDA2NDQKLS0tIGEvZnMvZG5vdGlmeS5jCisrKyBiL2ZzL2Ru
b3RpZnkuYwpAQCAtMjAsNiArMjAsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2luaXQuaD4KICNpbmNs
dWRlIDxsaW51eC9zcGlubG9jay5oPgogI2luY2x1ZGUgPGxpbnV4L3NsYWIuaD4KKyNpbmNsdWRl
IDxsaW51eC9maWxlLmg+CiAKIGludCBkaXJfbm90aWZ5X2VuYWJsZSBfX3JlYWRfbW9zdGx5ID0g
MTsKIApAQCAtNjYsNiArNjcsNyBAQCBpbnQgZmNudGxfZGlybm90aWZ5KGludCBmZCwgc3RydWN0
IGZpbGUgKmZpbHAsIHVuc2lnbmVkIGxvbmcgYXJnKQogCXN0cnVjdCBkbm90aWZ5X3N0cnVjdCAq
KnByZXY7CiAJc3RydWN0IGlub2RlICppbm9kZTsKIAlmbF9vd25lcl90IGlkID0gY3VycmVudC0+
ZmlsZXM7CisJc3RydWN0IGZpbGUgKmY7CiAJaW50IGVycm9yID0gMDsKIAogCWlmICgoYXJnICYg
fkROX01VTFRJU0hPVCkgPT0gMCkgewpAQCAtOTIsNiArOTQsMTUgQEAgaW50IGZjbnRsX2Rpcm5v
dGlmeShpbnQgZmQsIHN0cnVjdCBmaWxlICpmaWxwLCB1bnNpZ25lZCBsb25nIGFyZykKIAkJcHJl
diA9ICZvZG4tPmRuX25leHQ7CiAJfQogCisJcmN1X3JlYWRfbG9jaygpOworCWYgPSBmY2hlY2so
ZmQpOworCXJjdV9yZWFkX3VubG9jaygpOworCS8qIHdlJ2QgbG9zdCB0aGUgcmFjZSB3aXRoIGNs
b3NlKCksIHNvZCBvZmYgc2lsZW50bHkgKi8KKwkvKiBub3RlIHRoYXQgaW5vZGUtPmlfbG9jayBw
cmV2ZW50cyByZW9yZGVyaW5nIHByb2JsZW1zCisJICogYmV0d2VlbiBhY2Nlc3NlcyB0byBkZXNj
cmlwdG9yIHRhYmxlIGFuZCAtPmlfZG5vdGlmeSAqLworCWlmIChmICE9IGZpbHApCisJCWdvdG8g
b3V0X2ZyZWU7CisKIAllcnJvciA9IF9fZl9zZXRvd24oZmlscCwgdGFza19waWQoY3VycmVudCks
IFBJRFRZUEVfUElELCAwKTsKIAlpZiAoZXJyb3IpCiAJCWdvdG8gb3V0X2ZyZWU7Cg==
------=_Part_16292_16366960.1210178663282--

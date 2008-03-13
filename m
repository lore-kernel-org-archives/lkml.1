Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbYCMEGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbYCMEGe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 00:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750814AbYCMEG0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 00:06:26 -0400
Received: from rv-out-0910.google.com ([209.85.198.191]:28142 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbYCMEGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 00:06:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=TLrX83yYM8Rh3XzaHd/fVoMZF8cFVdIqaKA2mlW85IGPYIxxyW/RPVkIqzSrgVPDBnvVpVK/DQgS3XxkOwLTyunPPTi75NSFO5TQBf2K7YoVvi8MM2h4qBSp586uNF7N75qVubKQCxfRE0gpC4FneY34Y3mdRDXZ4daKslzGU80=
Message-ID: <469a066a0803122106r6c523a1o83c9e6d146e6c510@mail.gmail.com>
Date: Thu, 13 Mar 2008 12:06:24 +0800
From: "Jason Wu" <wenhsuan121@gmail.com>
To: mingo@redhat.com, vapier.adi@gmail.com
Subject: fixes the bug : ntfs build failure in linux-2.6.git on no-mmu
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3467_11779409.1205381185009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3467_11779409.1205381185009
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch fixes the bug : ntfs build failure in linux-2.6.git on no-mmu

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10164


Signed-off-by: Jason Wu <wenhsuan121@gmail.com>

------=_Part_3467_11779409.1205381185009
Content-Type: text/plain;
 name=0294-This-patch-fixes-the-bug-of-Bug-Entry-http.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdqsr23m
Content-Disposition: attachment;
 filename=0294-This-patch-fixes-the-bug-of-Bug-Entry-http.patch

RnJvbSBjN2UzMDUwMDVjODkzY2Q2MDViZTE2YjAxMGFiYzQyZjBiMjhiMjEwIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBKYXNvbiBXdSA8d2VuaHN1YW4xMjFAZ21haWwuY29tPgpEYXRl
OiBUaHUsIDEzIE1hciAyMDA4IDEyOjE0OjIwICswODAwClN1YmplY3Q6IFtQQVRDSF0gVGhpcyBw
YXRjaCBmaXhlcyB0aGUgYnVnIG9mIEJ1Zy1FbnRyeSAgICAgICA6IGh0dHA6Ly9idWd6aWxsYS5r
ZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD0xMDE2NAoKLS0tCiBpbmNsdWRlL2xpbnV4L21tLmgg
fCAgICA2ICsrKysrKwogMSBmaWxlcyBjaGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDAgZGVsZXRp
b25zKC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9tbS5oIGIvaW5jbHVkZS9saW51eC9t
bS5oCmluZGV4IDNmM2NjZmUuLjJmYTQ1YzQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvbW0u
aAorKysgYi9pbmNsdWRlL2xpbnV4L21tLmgKQEAgLTI0Myw2ICsyNDMsMTIgQEAgc3RhdGljIGlu
bGluZSBpbnQgaXNfdm1hbGxvY19hZGRyKGNvbnN0IHZvaWQgKngpCiAKIAlyZXR1cm4gYWRkciA+
PSBWTUFMTE9DX1NUQVJUICYmIGFkZHIgPCBWTUFMTE9DX0VORDsKIH0KKyNlbHNlCisvKiBKdXN0
IHJldHVybiAxIGFsbCB0aGUgdGltZSBmb3Igbm8tTU1VICovCitzdGF0aWMgaW5saW5lIGludCBp
c192bWFsbG9jX2FkZHIoY29uc3Qgdm9pZCAqeCkKK3sKKwlyZXR1cm4gMTsKK30KICNlbmRpZgog
CiBzdGF0aWMgaW5saW5lIHN0cnVjdCBwYWdlICpjb21wb3VuZF9oZWFkKHN0cnVjdCBwYWdlICpw
YWdlKQotLSAKMS41LjQKCg==
------=_Part_3467_11779409.1205381185009--

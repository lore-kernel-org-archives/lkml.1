Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbYCMG7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbYCMG7z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 02:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751333AbYCMG7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 02:59:47 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:14347 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbYCMG7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 02:59:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=RCPZeDlrLwe60D1VT7zheOkPdLIgUZ7+2qFa6cd3xuQGbrR3JDyX+wNnyENX/78uVUwF/6751YuS2ChvPAxcTMhxH4nsd40tny5gmEF3xfQjBNAMJOpbd5r0dZ2ppze94umQy/h0rD89Ae+ucz/gtp7xCzwua2YWH8feMackZsc=
Message-ID: <469a066a0803122359y75deba08yfef566d3f378e5ad@mail.gmail.com>
Date: Thu, 13 Mar 2008 14:59:45 +0800
From: "Jason Wu" <wenhsuan121@gmail.com>
To: mingo@redhat.com, vapier.adi@gmail.com
Subject: [PATCH] fixes the bug : ntfs build failure in linux-2.6.git on no-mmu
Cc: linux-kernel@vger.kernel.org, wenhsuan121@gmail.com
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_3603_25770761.1205391585904"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_3603_25770761.1205391585904
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This patch fixes the bug : ntfs build failure in linux-2.6.git on no-mmu

Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=10164


Signed-off-by: Jason Wu <wenhsuan121@gmail.com>

------=_Part_3603_25770761.1205391585904
Content-Type: text/plain;
 name=0294-This-patch-fixes-the-bug-of-Bug-Entry-http.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fdqz08vh
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
------=_Part_3603_25770761.1205391585904--

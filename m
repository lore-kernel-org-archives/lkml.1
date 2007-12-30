Return-Path: <linux-kernel-owner+w=401wt.eu-S1756920AbXL3NVK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920AbXL3NVK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:21:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbXL3NU5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:20:57 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:51121 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbXL3NU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:20:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=toovcXHyz1sftBhfq0KEyHI45s88rDRwKIN5xauABL/7H9uyVLWJKhyF9UiVo7rYunWlKT5qtk4+1Fs2CEih1HsTElVvvTGIkxNTZHn9QfYVq8E4puSnzH9XgweYrxzHU1qEWKf/C/3+X1YvduF5HIw+k1YvRfsypuCxq6urU74=
Message-ID: <6101e8c40712300520r7c702bc9o7411317c2d10cd25@mail.gmail.com>
Date: Sun, 30 Dec 2007 14:20:54 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [06/06] [typo fix] Documentation/filesystems/porting
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16342_12577539.1199020854629"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16342_12577539.1199020854629
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_16342_12577539.1199020854629
Content-Type: text/x-diff; name=06.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=06.patch

Y29tbWl0IDkzZDAyMWYxMmQ1MzcwZDA2YjFlZWUwNjU5ZDgzZDFlNzA5NWRmNmMKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkNvbW1pdDogT2xpdmVyIFBpbnRl
ciA8b2xpdmVyLnBudHJAZ21haWwuY29tPgoKICAgIFt0eXBvIGZpeF0gRG9jdW1lbnRhdGlvbi9m
aWxlc3lzdGVtcy9wb3J0aW5nCiAgICAKICAgIHR5cG8gZml4IGluIERvY3VtZW50YXRpb24vZmls
ZXN5c3RlbXMvcG9ydGluZwogICAgZm9vLWRlc3RvcnkgLT4gZm9vLWRlc3Ryb3kgJiYgd2hpdGVz
cGFjZSBjbGVhbnVwCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IE9saXZlciBQaW50ZXIgPG9saXZl
ci5wbnRyQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1z
L3BvcnRpbmcgYi9Eb2N1bWVudGF0aW9uL2ZpbGVzeXN0ZW1zL3BvcnRpbmcKaW5kZXggZGFjNDVj
OS4uMGYzM2M3NyAxMDA2NDQKLS0tIGEvRG9jdW1lbnRhdGlvbi9maWxlc3lzdGVtcy9wb3J0aW5n
CisrKyBiL0RvY3VtZW50YXRpb24vZmlsZXN5c3RlbXMvcG9ydGluZwpAQCAtMSw2ICsxLDYgQEAK
IENoYW5nZXMgc2luY2UgMi41LjA6CiAKLS0tLSAKKy0tLQogW3JlY29tbWVuZGVkXQogCiBOZXcg
aGVscGVyczogc2JfYnJlYWQoKSwgc2JfZ2V0YmxrKCksIHNiX2ZpbmRfZ2V0X2Jsb2NrKCksIHNl
dF9iaCgpLApAQCAtMTAsNyArMTAsNyBAQCBVc2UgdGhlbS4KIAogKHNiX2ZpbmRfZ2V0X2Jsb2Nr
KCkgcmVwbGFjZXMgMi40J3MgZ2V0X2hhc2hfdGFibGUoKSkKIAotLS0tIAorLS0tCiBbcmVjb21t
ZW5kZWRdCiAKIE5ldyBtZXRob2RzOiAtPmFsbG9jX2lub2RlKCkgYW5kIC0+ZGVzdHJveV9pbm9k
ZSgpLgpAQCAtMjgsNyArMjgsNyBAQCBEZWNsYXJlCiAKIFVzZSBGT09fSShpbm9kZSkgaW5zdGVh
ZCBvZiAmaW5vZGUtPnUuZm9vX2lub2RlX2k7CiAKLUFkZCBmb29fYWxsb2NfaW5vZGUoKSBhbmQg
Zm9vX2Rlc3RvcnlfaW5vZGUoKSAtIHRoZSBmb3JtZXIgc2hvdWxkIGFsbG9jYXRlCitBZGQgZm9v
X2FsbG9jX2lub2RlKCkgYW5kIGZvb19kZXN0cm95X2lub2RlKCkgLSB0aGUgZm9ybWVyIHNob3Vs
ZCBhbGxvY2F0ZQogZm9vX2lub2RlX2luZm8gYW5kIHJldHVybiB0aGUgYWRkcmVzcyBvZiAtPnZm
c19pbm9kZSwgdGhlIGxhdHRlciBzaG91bGQgZnJlZQogRk9PX0koaW5vZGUpIChzZWUgaW4tdHJl
ZSBmaWxlc3lzdGVtcyBmb3IgZXhhbXBsZXMpLgogCg==
------=_Part_16342_12577539.1199020854629--

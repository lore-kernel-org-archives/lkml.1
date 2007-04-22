Return-Path: <linux-kernel-owner+w=401wt.eu-S1030521AbXDVTZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030521AbXDVTZF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030524AbXDVTZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:25:05 -0400
Received: from nic2.axis.se ([193.13.178.10]:39179 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030521AbXDVTZE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:25:04 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.0.6603.0
content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C78513.E1329B30"
Subject: [PATCH 2.6.20 2/14] CRIS architecture update - subarchs
Date: Sun, 22 Apr 2007 21:24:43 +0200
Message-ID: <BFECAF9E178F144FAEF2BF4CE739C66803BEEE18@exmail1.se.axis.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 2.6.20 2/14] CRIS architecture update - subarchs
Thread-Index: AceFEgZr8M/nruwQSiC/o60KIIa7ag==
From: "Mikael Starvik" <mikael.starvik@axis.com>
To: <linux-kernel@vger.kernel.org>
Cc: <akpm@linux-foundation.org>
X-OriginalArrivalTime: 22 Apr 2007 19:24:45.0271 (UTC) FILETIME=[E2685670:01C78513]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C78513.E1329B30
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: base64

VGhlIGF0dGFjaGVkIHBhdGNoIGNvcnJlY3RzIGEgZmV3IHBhdGhzIHJlbGF0ZWQgdG8gc3ViLWFy
Y2hpdGVjdHVyZXMuDQogDQpTaWduZWQtb2ZmLWJ5OiBNaWthZWwgU3RhcnZpayA8c3RhcnZpa0Bh
eGlzLmNvbT4NCiANCi9NaWthZWwNCg==

------_=_NextPart_001_01C78513.E1329B30
Content-Type: application/octet-stream;
	name="cris2_arch.patch"
Content-Transfer-Encoding: base64
Content-Description: cris2_arch.patch
Content-Disposition: attachment;
	filename="cris2_arch.patch"

ZGlmZiAtdXJOUCAtLWV4Y2x1ZGU9JyouY3ZzaWdub3JlJyAuLi9saW51eC9hcmNoL2NyaXMvYXJj
aC12MTAvYm9vdC9yZXNjdWUva2ltYWdlcmVzY3VlLlMgbGludXgtMi42L2FyY2gvY3Jpcy9hcmNo
LXYxMC9ib290L3Jlc2N1ZS9raW1hZ2VyZXNjdWUuUwotLS0gLi4vbGludXgvYXJjaC9jcmlzL2Fy
Y2gtdjEwL2Jvb3QvcmVzY3VlL2tpbWFnZXJlc2N1ZS5TCTIwMDctMDItMDQgMTk6NDQ6NTQuMDAw
MDAwMDAwICswMTAwCisrKyBsaW51eC0yLjYvYXJjaC9jcmlzL2FyY2gtdjEwL2Jvb3QvcmVzY3Vl
L2tpbWFnZXJlc2N1ZS5TCTIwMDYtMTEtMjkgMTc6MDU6NDEuMDAwMDAwMDAwICswMTAwCkBAIC0x
LDQgKzEsNCBAQAotLyogJElkOiBraW1hZ2VyZXNjdWUuUyx2IDEuMSAyMDAxLzEyLzE3IDEzOjU5
OjI3IGJqb3JudyBFeHAgJAorLyogJElkOiBraW1hZ2VyZXNjdWUuUyx2IDEuMyAyMDA2LzExLzI5
IDE2OjA1OjQxIHJpY2FyZHcgRXhwICQKICAqIAogICogUmVzY3VlIGNvZGUgdG8gYmUgcHJlcGVu
ZGVkIG9uIGEga2ltYWdlIGFuZCBjb3BpZWQgdG8gdGhlCiAgKiByZXNjdWUgc2VyaWFsIHBvcnQu
CkBAIC03LDcgKzcsNyBAQAogICovCiAKICNkZWZpbmUgQVNTRU1CTEVSX01BQ1JPU19PTkxZCi0j
aW5jbHVkZSA8YXNtL3N2X2FkZHJfYWcuaD4KKyNpbmNsdWRlIDxhc20vYXJjaC9zdl9hZGRyX2Fn
Lmg+CiAKICNkZWZpbmUgQ09ERV9TVEFSVCAweDQwMDA0MDAwCiAjZGVmaW5lIENPREVfTEVOR1RI
IDc4NApkaWZmIC11ck5QIC0tZXhjbHVkZT0nKi5jdnNpZ25vcmUnIC4uL2xpbnV4L2FyY2gvY3Jp
cy9hcmNoLXYxMC9ib290L3Jlc2N1ZS90ZXN0cmVzY3VlLlMgbGludXgtMi42L2FyY2gvY3Jpcy9h
cmNoLXYxMC9ib290L3Jlc2N1ZS90ZXN0cmVzY3VlLlMKLS0tIC4uL2xpbnV4L2FyY2gvY3Jpcy9h
cmNoLXYxMC9ib290L3Jlc2N1ZS90ZXN0cmVzY3VlLlMJMjAwNy0wMi0wNCAxOTo0NDo1NC4wMDAw
MDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNi9hcmNoL2NyaXMvYXJjaC12MTAvYm9vdC9yZXNjdWUv
dGVzdHJlc2N1ZS5TCTIwMDYtMTEtMjkgMTc6MDU6NDEuMDAwMDAwMDAwICswMTAwCkBAIC0xLDQg
KzEsNCBAQAotLyogJElkOiB0ZXN0cmVzY3VlLlMsdiAxLjEgMjAwMS8xMi8xNyAxMzo1OToyNyBi
am9ybncgRXhwICQKKy8qICRJZDogdGVzdHJlc2N1ZS5TLHYgMS4yIDIwMDYvMTEvMjkgMTY6MDU6
NDEgcmljYXJkdyBFeHAgJAogICoKICAqIFNpbXBsZSB0ZXN0Y29kZSB0byBkb3dubG9hZCBieSB0
aGUgcmVzY3VlIGJsb2NrLgogICogSnVzdCBsaXRzIHNvbWUgTEVEcyB0byBzaG93IGl0IHdhcyBk
b3dubG9hZGVkIGNvcnJlY3RseS4KQEAgLTcsNyArNyw3IEBACiAgKi8KIAogI2RlZmluZSBBU1NF
TUJMRVJfTUFDUk9TX09OTFkKLSNpbmNsdWRlIDxhc20vc3ZfYWRkcl9hZy5oPgorI2luY2x1ZGUg
PGFzbS9hcmNoL3N2X2FkZHJfYWcuaD4KIAogCS50ZXh0CiAK

------_=_NextPart_001_01C78513.E1329B30--

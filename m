Return-Path: <linux-kernel-owner+w=401wt.eu-S1756851AbXL3NRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756851AbXL3NRx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 08:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXL3NRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 08:17:46 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:46597 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbXL3NRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 08:17:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=qS3+gLQ/BZCSx1lGVrImrmkxhoh0YPTHNyGkw7FRgwDOU8wScqR1YE9pgFHeRsQUp8X/bgf+EnpJXkmjraf2fPByGjSJoYqFPvCsC/jaorc0x8ID7njzQO/Fz/RLke+bhaUCutV0uzXh2nwlyccx77WbaD0CQVs/xpwBO2/NM6k=
Message-ID: <6101e8c40712300517n10d8d05bve4ef44f948ffcb55@mail.gmail.com>
Date: Sun, 30 Dec 2007 14:17:43 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [00/06] [typo fix] net/sctp/sm_statefuns.c
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_16326_20594820.1199020663565"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_16326_20594820.1199020663565
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_16326_20594820.1199020663565
Content-Type: text/x-diff; name=01.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=01.patch

Y29tbWl0IDhmMTk0ZTcwYTU4ZDM0NTUwMzNhOTc4ODAxNDYxOTQyMzg1N2ZiYTkKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkNvbW1pdDogT2xpdmVyIFBpbnRl
ciA8b2xpdmVyLnBudHJAZ21haWwuY29tPgoKICAgIFt0eXBvIGZpeF0gbmV0L3NjdHAvc21fc3Rh
dGVmdW5zLmMKICAgIAogICAgdHlwbyBmaXggaW4gbmV0L3NjdHAvc21fc3RhdGVmdW5zLmMKICAg
IGZvby1kZXN0b3J5IC0+IGZvby1kZXN0cm95CiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IE9saXZl
ciBQaW50ZXIgPG9saXZlci5wbnRyQGdtYWlsLmNvbT4KCmRpZmYgLS1naXQgYS9uZXQvc2N0cC9z
bV9zdGF0ZWZ1bnMuYyBiL25ldC9zY3RwL3NtX3N0YXRlZnVucy5jCmluZGV4IDVmYjg0NzcuLjE4
NzMzY2UgMTAwNjQ0Ci0tLSBhL25ldC9zY3RwL3NtX3N0YXRlZnVucy5jCisrKyBiL25ldC9zY3Rw
L3NtX3N0YXRlZnVucy5jCkBAIC01MzMsNyArNTMzLDcgQEAgc2N0cF9kaXNwb3NpdGlvbl90IHNj
dHBfc2ZfZG9fNV8xQ19hY2soY29uc3Qgc3RydWN0IHNjdHBfZW5kcG9pbnQgKmVwLAogCQkgKgog
CQkgKiBUaGlzIG1lYW5zIHRoYXQgaWYgd2Ugb25seSB3YW50IHRvIGFib3J0IGFzc29jaWF0aW9u
cwogCQkgKiBpbiBhbiBhdXRoZW50aWNhdGVkIHdheSAoaS5lIEFVVEgrQUJPUlQpLCB0aGVuIHdl
Ci0JCSAqIGNhbid0IGRlc3RvcnkgdGhpcyBhc3NvY2lhdGlvbiBqdXN0IGJlY3Vhc2UgdGhlIHBh
Y2tldAorCQkgKiBjYW4ndCBkZXN0cm95IHRoaXMgYXNzb2NpYXRpb24ganVzdCBiZWN1YXNlIHRo
ZSBwYWNrZXQKIAkJICogd2FzIG1hbGZvcm1lZC4KIAkJICovCiAJCWlmIChzY3RwX2F1dGhfcmVj
dl9jaWQoU0NUUF9DSURfQUJPUlQsIGFzb2MpKQpAQCAtNDA3Miw3ICs0MDcyLDcgQEAgc3RhdGlj
IHNjdHBfZGlzcG9zaXRpb25fdCBzY3RwX3NmX2Fib3J0X3Zpb2xhdGlvbigKIAkgKgogCSAqIFRo
aXMgbWVhbnMgdGhhdCBpZiB3ZSBvbmx5IHdhbnQgdG8gYWJvcnQgYXNzb2NpYXRpb25zCiAJICog
aW4gYW4gYXV0aGVudGljYXRlZCB3YXkgKGkuZSBBVVRIK0FCT1JUKSwgdGhlbiB3ZQotCSAqIGNh
bid0IGRlc3RvcnkgdGhpcyBhc3NvY2lhdGlvbiBqdXN0IGJlY3Vhc2UgdGhlIHBhY2tldAorCSAq
IGNhbid0IGRlc3Ryb3kgdGhpcyBhc3NvY2lhdGlvbiBqdXN0IGJlY3Vhc2UgdGhlIHBhY2tldAog
CSAqIHdhcyBtYWxmb3JtZWQuCiAJICovCiAJaWYgKHNjdHBfYXV0aF9yZWN2X2NpZChTQ1RQX0NJ
RF9BQk9SVCwgYXNvYykpCg==
------=_Part_16326_20594820.1199020663565--

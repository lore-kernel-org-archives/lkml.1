Return-Path: <linux-kernel-owner+w=401wt.eu-S1765077AbYA1XTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765077AbYA1XTz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764312AbYA1XOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:14:09 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764309AbYA1XOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:14:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=ZG3a/C4FA3V9h2L39jiAoMnZ1M3dw/3FS1Qg737FQR8GNA0CiX0CsdkDpatjGcHWcQ03pZMdhn64w8uRkZ9xm1GGU+Q7Zops1Rz8q4N42+GWTCxysvvvR05YDBF0NGpY8yhW9g9ybTkP13gCzWWLw0WyOf9PUO4uGO1ORVGr1AQ=
Message-ID: <6101e8c40801281514t1c117c3ei58f12bea86749a5f@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:14:00 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {13/17} - nfs-fix-nfs-reval-fsid - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       NeilBrown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8121_32466261.1201562040454"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8121_32466261.1201562040454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8121_32466261.1201562040454
Content-Type: text/x-diff; name=nfs-fix-nfs-reval-fsid
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfs-fix-nfs-reval-fsid

Y29tbWl0IGMxZjIwOGE4ZjdmMTUzMmY3NDY3NjhiYTE4OWU1NGM0NDZmY2Y1ZTMKQXV0aG9yOiBP
bGl2ZXIgUGludGVyIDxvbGl2ZXIucG50ckBnbWFpbC5jb20+CkRhdGU6ICAgTW9uIEphbiAyOCAy
MToxMzozOSAyMDA4ICswMTAwCgogICAgUGF0Y2gtbWFpbmxpbmU6IDIuNi4yNAogICAgUmVmZXJl
bmNlczogMjcxODAzCiAgICBHSVQ6IGEwMzU2ODYyYmNiZWIyMGFjZjY0YmMxYTgyZDI4YTRjNWJi
OTU3YTcgTW9uIFNlcCAxNyAwMDowMDowMCAyMDAxCiAgICBGcm9tOiBUcm9uZCBNeWtsZWJ1c3Qg
PFRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tPgogICAgRGF0ZTogVHVlLCA1IEp1biAyMDA3IDEz
OjI2OjE1IC0wNDAwCiAgICBTdWJqZWN0OiBbUEFUQ0hdIE5GUzogRml4IG5mc19yZXZhbF9mc2lk
KCkKICAgIAogICAgV2UgZG9uJ3QgbmVlZCB0byByZXZhbGlkYXRlIHRoZSBmc2lkIG9uIHRoZSBy
b290IGRpcmVjdG9yeS4gSXQgc3VmZmljZXMgdG8KICAgIHJldmFsaWRhdGUgaXQgb24gdGhlIGN1
cnJlbnQgZGlyZWN0b3J5LgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBUcm9uZCBNeWtsZWJ1c3Qg
PFRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tPgogICAgQWNrZWQtYnk6IE5laWxCcm93biA8bmVp
bGJAc3VzZS5kZT4KCmRpZmYgLS1naXQgYS9mcy9uZnMvZGlyLmMgYi9mcy9uZnMvZGlyLmMKaW5k
ZXggYzI3MjU4Yi4uOTVmMjYzMSAxMDA2NDQKLS0tIGEvZnMvbmZzL2Rpci5jCisrKyBiL2ZzL25m
cy9kaXIuYwpAQCAtODk3LDE0ICs4OTcsMTMgQEAgaW50IG5mc19pc19leGNsdXNpdmVfY3JlYXRl
KHN0cnVjdCBpbm9kZSAqZGlyLCBzdHJ1Y3QgbmFtZWlkYXRhICpuZCkKIAlyZXR1cm4gKG5kLT5p
bnRlbnQub3Blbi5mbGFncyAmIE9fRVhDTCkgIT0gMDsKIH0KIAotc3RhdGljIGlubGluZSBpbnQg
bmZzX3JldmFsX2ZzaWQoc3RydWN0IHZmc21vdW50ICptbnQsIHN0cnVjdCBpbm9kZSAqZGlyLAot
CQkJCSBzdHJ1Y3QgbmZzX2ZoICpmaCwgc3RydWN0IG5mc19mYXR0ciAqZmF0dHIpCitzdGF0aWMg
aW5saW5lIGludCBuZnNfcmV2YWxfZnNpZChzdHJ1Y3QgaW5vZGUgKmRpciwgY29uc3Qgc3RydWN0
IG5mc19mYXR0ciAqZmF0dHIpCiB7CiAJc3RydWN0IG5mc19zZXJ2ZXIgKnNlcnZlciA9IE5GU19T
RVJWRVIoZGlyKTsKIAogCWlmICghbmZzX2ZzaWRfZXF1YWwoJnNlcnZlci0+ZnNpZCwgJmZhdHRy
LT5mc2lkKSkKLQkJLyogUmV2YWxpZGF0ZSBmc2lkIG9uIHJvb3QgZGlyICovCi0JCXJldHVybiBf
X25mc19yZXZhbGlkYXRlX2lub2RlKHNlcnZlciwgbW50LT5tbnRfcm9vdC0+ZF9pbm9kZSk7CisJ
CS8qIFJldmFsaWRhdGUgZnNpZCB1c2luZyB0aGUgcGFyZW50IGRpcmVjdG9yeSAqLworCQlyZXR1
cm4gX19uZnNfcmV2YWxpZGF0ZV9pbm9kZShzZXJ2ZXIsIGRpcik7CiAJcmV0dXJuIDA7CiB9CiAK
QEAgLTk0Niw3ICs5NDUsNyBAQCBzdGF0aWMgc3RydWN0IGRlbnRyeSAqbmZzX2xvb2t1cChzdHJ1
Y3QgaW5vZGUgKmRpciwgc3RydWN0IGRlbnRyeSAqIGRlbnRyeSwgc3RydQogCQlyZXMgPSBFUlJf
UFRSKGVycm9yKTsKIAkJZ290byBvdXRfdW5sb2NrOwogCX0KLQllcnJvciA9IG5mc19yZXZhbF9m
c2lkKG5kLT5tbnQsIGRpciwgJmZoYW5kbGUsICZmYXR0cik7CisJZXJyb3IgPSBuZnNfcmV2YWxf
ZnNpZChkaXIsICZmYXR0cik7CiAJaWYgKGVycm9yIDwgMCkgewogCQlyZXMgPSBFUlJfUFRSKGVy
cm9yKTsKIAkJZ290byBvdXRfdW5sb2NrOwpkaWZmIC0tZ2l0IGEvZnMvbmZzL2lub2RlLmMgYi9m
cy9uZnMvaW5vZGUuYwppbmRleCBiZDlmNWE4Li4yMjE5YjZjIDEwMDY0NAotLS0gYS9mcy9uZnMv
aW5vZGUuYworKysgYi9mcy9uZnMvaW5vZGUuYwpAQCAtOTYxLDggKzk2MSw4IEBAIHN0YXRpYyBp
bnQgbmZzX3VwZGF0ZV9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgbmZzX2ZhdHRy
ICpmYXR0cikKIAkJZ290byBvdXRfY2hhbmdlZDsKIAogCXNlcnZlciA9IE5GU19TRVJWRVIoaW5v
ZGUpOwotCS8qIFVwZGF0ZSB0aGUgZnNpZCBpZiBhbmQgb25seSBpZiB0aGlzIGlzIHRoZSByb290
IGRpcmVjdG9yeSAqLwotCWlmIChpbm9kZSA9PSBpbm9kZS0+aV9zYi0+c19yb290LT5kX2lub2Rl
CisJLyogVXBkYXRlIHRoZSBmc2lkPyAqLworCWlmIChTX0lTRElSKGlub2RlLT5pX21vZGUpCiAJ
CQkmJiAhbmZzX2ZzaWRfZXF1YWwoJnNlcnZlci0+ZnNpZCwgJmZhdHRyLT5mc2lkKSkKIAkJc2Vy
dmVyLT5mc2lkID0gZmF0dHItPmZzaWQ7CiAK
------=_Part_8121_32466261.1201562040454--

Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbYBBBii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbYBBBii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764220AbYBBBei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:34:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764214AbYBBBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:34:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=irYhP/hh6qnP7fAhZmydMKNY2hZAF8HgfE6E2VRItIFYlGHXVpqEG4DGrilDtpJ/mBvlkkH0ZeWRrhnV/fNP1QTzuJ86E+CuvmYhg31wk8WmKIs+/WBQetjUjcs+AKtkm6mWRFISlIaNzBVqAfqAKC7UM6GpAmvfb/I7ijv6fvo=
Message-ID: <6101e8c40802011734q5f98edc6lb0b3d2ebcbb533bd@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:34:34 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {13/17} - nfs-fix-nfs-reval-fsid - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Trond Myklebust" <Trond.Myklebust@netapp.com>,
       NeilBrown <neilb@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26279_4738696.1201916074454"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26279_4738696.1201916074454
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: a0356862bcbeb20acf64bc1a82d28a4c5bb957a7


-- 
Thanks,
Oliver

------=_Part_26279_4738696.1201916074454
Content-Type: text/x-diff; name=nfs-fix-nfs-reval-fsid
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfs-fix-nfs-reval-fsid

UGF0Y2gtbWFpbmxpbmU6IDIuNi4yNApSZWZlcmVuY2VzOiAyNzE4MDMKR0lUOiBhMDM1Njg2MmJj
YmViMjBhY2Y2NGJjMWE4MmQyOGE0YzViYjk1N2E3IE1vbiBTZXAgMTcgMDA6MDA6MDAgMjAwMQpG
cm9tOiBUcm9uZCBNeWtsZWJ1c3QgPFRyb25kLk15a2xlYnVzdEBuZXRhcHAuY29tPgpEYXRlOiBU
dWUsIDUgSnVuIDIwMDcgMTM6MjY6MTUgLTA0MDAKU3ViamVjdDogW1BBVENIXSBORlM6IEZpeCBu
ZnNfcmV2YWxfZnNpZCgpCgpXZSBkb24ndCBuZWVkIHRvIHJldmFsaWRhdGUgdGhlIGZzaWQgb24g
dGhlIHJvb3QgZGlyZWN0b3J5LiBJdCBzdWZmaWNlcyB0bwpyZXZhbGlkYXRlIGl0IG9uIHRoZSBj
dXJyZW50IGRpcmVjdG9yeS4KClNpZ25lZC1vZmYtYnk6IFRyb25kIE15a2xlYnVzdCA8VHJvbmQu
TXlrbGVidXN0QG5ldGFwcC5jb20+CkFja2VkLWJ5OiBOZWlsQnJvd24gPG5laWxiQHN1c2UuZGU+
CgotLS0KIGZzL25mcy9kaXIuYyAgIHwgICAgOSArKysrLS0tLS0KIGZzL25mcy9pbm9kZS5jIHwg
ICAgNCArKy0tCiAyIGZpbGVzIGNoYW5nZWQsIDYgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlvbnMo
LSkKCmRpZmYgLS1naXQgYS9mcy9uZnMvZGlyLmMgYi9mcy9uZnMvZGlyLmMKaW5kZXggNDk0OGVj
MS4uYzAyYTc5NiAxMDA2NDQKLS0tIGEvZnMvbmZzL2Rpci5jCisrKyBiL2ZzL25mcy9kaXIuYwpA
QCAtODk3LDE0ICs4OTcsMTMgQEAgaW50IG5mc19pc19leGNsdXNpdmVfY3JlYXRlKHN0cnVjdCBp
bm9kZSAqZGlyLCBzdHJ1Y3QgbmFtZWlkYXRhICpuZCkKIAlyZXR1cm4gKG5kLT5pbnRlbnQub3Bl
bi5mbGFncyAmIE9fRVhDTCkgIT0gMDsKIH0KIAotc3RhdGljIGlubGluZSBpbnQgbmZzX3JldmFs
X2ZzaWQoc3RydWN0IHZmc21vdW50ICptbnQsIHN0cnVjdCBpbm9kZSAqZGlyLAotCQkJCSBzdHJ1
Y3QgbmZzX2ZoICpmaCwgc3RydWN0IG5mc19mYXR0ciAqZmF0dHIpCitzdGF0aWMgaW5saW5lIGlu
dCBuZnNfcmV2YWxfZnNpZChzdHJ1Y3QgaW5vZGUgKmRpciwgY29uc3Qgc3RydWN0IG5mc19mYXR0
ciAqZmF0dHIpCiB7CiAJc3RydWN0IG5mc19zZXJ2ZXIgKnNlcnZlciA9IE5GU19TRVJWRVIoZGly
KTsKIAogCWlmICghbmZzX2ZzaWRfZXF1YWwoJnNlcnZlci0+ZnNpZCwgJmZhdHRyLT5mc2lkKSkK
LQkJLyogUmV2YWxpZGF0ZSBmc2lkIG9uIHJvb3QgZGlyICovCi0JCXJldHVybiBfX25mc19yZXZh
bGlkYXRlX2lub2RlKHNlcnZlciwgbW50LT5tbnRfcm9vdC0+ZF9pbm9kZSk7CisJCS8qIFJldmFs
aWRhdGUgZnNpZCB1c2luZyB0aGUgcGFyZW50IGRpcmVjdG9yeSAqLworCQlyZXR1cm4gX19uZnNf
cmV2YWxpZGF0ZV9pbm9kZShzZXJ2ZXIsIGRpcik7CiAJcmV0dXJuIDA7CiB9CiAKQEAgLTk0Niw3
ICs5NDUsNyBAQCBzdGF0aWMgc3RydWN0IGRlbnRyeSAqbmZzX2xvb2t1cChzdHJ1Y3QgaW5vZGUg
KmRpciwgc3RydWN0IGRlbnRyeSAqIGRlbnRyeSwgc3RydQogCQlyZXMgPSBFUlJfUFRSKGVycm9y
KTsKIAkJZ290byBvdXRfdW5sb2NrOwogCX0KLQllcnJvciA9IG5mc19yZXZhbF9mc2lkKG5kLT5t
bnQsIGRpciwgJmZoYW5kbGUsICZmYXR0cik7CisJZXJyb3IgPSBuZnNfcmV2YWxfZnNpZChkaXIs
ICZmYXR0cik7CiAJaWYgKGVycm9yIDwgMCkgewogCQlyZXMgPSBFUlJfUFRSKGVycm9yKTsKIAkJ
Z290byBvdXRfdW5sb2NrOwpkaWZmIC0tZ2l0IGEvZnMvbmZzL2lub2RlLmMgYi9mcy9uZnMvaW5v
ZGUuYwppbmRleCAyM2VjZjAzLi43YmNiM2RmIDEwMDY0NAotLS0gYS9mcy9uZnMvaW5vZGUuYwor
KysgYi9mcy9uZnMvaW5vZGUuYwpAQCAtOTYxLDggKzk2MSw4IEBAIHN0YXRpYyBpbnQgbmZzX3Vw
ZGF0ZV9pbm9kZShzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgbmZzX2ZhdHRyICpmYXR0cikK
IAkJZ290byBvdXRfY2hhbmdlZDsKIAogCXNlcnZlciA9IE5GU19TRVJWRVIoaW5vZGUpOwotCS8q
IFVwZGF0ZSB0aGUgZnNpZCBpZiBhbmQgb25seSBpZiB0aGlzIGlzIHRoZSByb290IGRpcmVjdG9y
eSAqLwotCWlmIChpbm9kZSA9PSBpbm9kZS0+aV9zYi0+c19yb290LT5kX2lub2RlCisJLyogVXBk
YXRlIHRoZSBmc2lkPyAqLworCWlmIChTX0lTRElSKGlub2RlLT5pX21vZGUpCiAJCQkmJiAhbmZz
X2ZzaWRfZXF1YWwoJnNlcnZlci0+ZnNpZCwgJmZhdHRyLT5mc2lkKSkKIAkJc2VydmVyLT5mc2lk
ID0gZmF0dHItPmZzaWQ7CiAKLS0gCjEuNS4zLjYKCg==
------=_Part_26279_4738696.1201916074454--

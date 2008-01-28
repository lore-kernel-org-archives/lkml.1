Return-Path: <linux-kernel-owner+w=401wt.eu-S1761746AbYA1XQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761746AbYA1XQj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763840AbYA1XNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:13:40 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764317AbYA1XNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=gq4Po0C2ZyuojJJdAPrN1PnYHDJgbogTXsFf3Wl9wOkHPXCFXFGdh2T1XzdsCNPqoPiRyZHBTs2a9yicDzmlVsK3zbi2Z/NH3vbNiqDllxuOxPKCOowNPX991ulcp9E0cJNI70cl78Qk3k++9JRyg5zmF5TlOdA2lmAnIgmLwfc=
Message-ID: <6101e8c40801281513j75b9fde9x242e17f08122e82b@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:37 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {06/17} - handle-bogus-%cs-selector-in-single-step-instruction-decoding - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Roland McGrath" <roland@redhat.com>, "Jeff Mahoney" <jeffm@suse.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8106_7964408.1201562017911"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8106_7964408.1201562017911
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8106_7964408.1201562017911
Content-Type: text/x-diff;
 name=handle-bogus-%cs-selector-in-single-step-instruction-decoding
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=handle-bogus-%cs-selector-in-single-step-instruction-decoding

Y29tbWl0IGQxNmNiODZlNzE5MDhlYzg2YWRkYzdmMWMwOTM0ZDAwY2ZiYzU1ZWQKQXV0aG9yOiBS
b2xhbmQgTWNHcmF0aCA8cm9sYW5kQHJlZGhhdC5jb20+CkRhdGU6ICAgTW9uIEp1bCAxNiAwODow
MzoxNiAyMDA3IC0wNzAwCgogICAgU3ViamVjdDogSGFuZGxlIGJvZ3VzICVjcyBzZWxlY3RvciBp
biBzaW5nbGUtc3RlcCBpbnN0cnVjdGlvbiBkZWNvZGluZwogICAgUGF0Y2gtbWFpbmxpbmU6IDIu
Ni4yMy1yYzEKICAgIFJlZmVyZW5jZXM6IDMyNjI3MCwgQ1ZFLTIwMDctMzczMQogICAgCiAgICBI
YW5kbGUgYm9ndXMgJWNzIHNlbGVjdG9yIGluIHNpbmdsZS1zdGVwIGluc3RydWN0aW9uIGRlY29k
aW5nCiAgICAKICAgIFRoZSBjb2RlIGZvciBMRFQgc2VnbWVudCBzZWxlY3RvcnMgd2FzIG5vdCBy
b2J1c3QgaW4gdGhlIGZhY2Ugb2YgYSBib2d1cwogICAgc2VsZWN0b3Igc2V0IGluICVjcyB2aWEg
cHRyYWNlIGJlZm9yZSB0aGUgc2luZ2xlLXN0ZXAgd2FzIGRvbmUuCiAgICAKICAgIFNpZ25lZC1v
ZmYtYnk6IFJvbGFuZCBNY0dyYXRoIDxyb2xhbmRAcmVkaGF0LmNvbT4KICAgIFNpZ25lZC1vZmYt
Ynk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1mb3VuZGF0aW9uLm9yZz4KICAgIEFj
a2VkLWJ5OiBKZWZmIE1haG9uZXkgPGplZmZtQHN1c2UuY29tPgoKZGlmZiAtLWdpdCBhL2FyY2gv
aTM4Ni9rZXJuZWwvcHRyYWNlLmMgYi9hcmNoL2kzODYva2VybmVsL3B0cmFjZS5jCmluZGV4IDBj
MGNlZWMuLjEyMGE2M2IgMTAwNjQ0Ci0tLSBhL2FyY2gvaTM4Ni9rZXJuZWwvcHRyYWNlLmMKKysr
IGIvYXJjaC9pMzg2L2tlcm5lbC9wdHJhY2UuYwpAQCAtMTY0LDE0ICsxNjQsMjIgQEAgc3RhdGlj
IHVuc2lnbmVkIGxvbmcgY29udmVydF9laXBfdG9fbGluZWFyKHN0cnVjdCB0YXNrX3N0cnVjdCAq
Y2hpbGQsIHN0cnVjdCBwdF8KIAkJdTMyICpkZXNjOwogCQl1bnNpZ25lZCBsb25nIGJhc2U7CiAK
LQkJZG93bigmY2hpbGQtPm1tLT5jb250ZXh0LnNlbSk7Ci0JCWRlc2MgPSBjaGlsZC0+bW0tPmNv
bnRleHQubGR0ICsgKHNlZyAmIH43KTsKLQkJYmFzZSA9IChkZXNjWzBdID4+IDE2KSB8ICgoZGVz
Y1sxXSAmIDB4ZmYpIDw8IDE2KSB8IChkZXNjWzFdICYgMHhmZjAwMDAwMCk7CisJCXNlZyAmPSB+
N1VMOwogCi0JCS8qIDE2LWJpdCBjb2RlIHNlZ21lbnQ/ICovCi0JCWlmICghKChkZXNjWzFdID4+
IDIyKSAmIDEpKQotCQkJYWRkciAmPSAweGZmZmY7Ci0JCWFkZHIgKz0gYmFzZTsKKwkJZG93bigm
Y2hpbGQtPm1tLT5jb250ZXh0LnNlbSk7CisJCWlmICh1bmxpa2VseSgoc2VnID4+IDMpID49IGNo
aWxkLT5tbS0+Y29udGV4dC5zaXplKSkKKwkJCWFkZHIgPSAtMUw7IC8qIGJvZ3VzIHNlbGVjdG9y
LCBhY2Nlc3Mgd291bGQgZmF1bHQgKi8KKwkJZWxzZSB7CisJCQlkZXNjID0gY2hpbGQtPm1tLT5j
b250ZXh0LmxkdCArIHNlZzsKKwkJCWJhc2UgPSAoKGRlc2NbMF0gPj4gMTYpIHwKKwkJCQkoKGRl
c2NbMV0gJiAweGZmKSA8PCAxNikgfAorCQkJCShkZXNjWzFdICYgMHhmZjAwMDAwMCkpOworCisJ
CQkvKiAxNi1iaXQgY29kZSBzZWdtZW50PyAqLworCQkJaWYgKCEoKGRlc2NbMV0gPj4gMjIpICYg
MSkpCisJCQkJYWRkciAmPSAweGZmZmY7CisJCQlhZGRyICs9IGJhc2U7CisJCX0KIAkJdXAoJmNo
aWxkLT5tbS0+Y29udGV4dC5zZW0pOwogCX0KIAlyZXR1cm4gYWRkcjsKZGlmZiAtLWdpdCBhL2Fy
Y2gveDg2XzY0L2tlcm5lbC9wdHJhY2UuYyBiL2FyY2gveDg2XzY0L2tlcm5lbC9wdHJhY2UuYwpp
bmRleCA4ZDg5ZDhjLi43ZmMwZTczIDEwMDY0NAotLS0gYS9hcmNoL3g4Nl82NC9rZXJuZWwvcHRy
YWNlLmMKKysrIGIvYXJjaC94ODZfNjQva2VybmVsL3B0cmFjZS5jCkBAIC0xMDIsMTYgKzEwMiwy
NSBAQCB1bnNpZ25lZCBsb25nIGNvbnZlcnRfcmlwX3RvX2xpbmVhcihzdHJ1Y3QgdGFza19zdHJ1
Y3QgKmNoaWxkLCBzdHJ1Y3QgcHRfcmVncyAqcgogCQl1MzIgKmRlc2M7CiAJCXVuc2lnbmVkIGxv
bmcgYmFzZTsKIAotCQlkb3duKCZjaGlsZC0+bW0tPmNvbnRleHQuc2VtKTsKLQkJZGVzYyA9IGNo
aWxkLT5tbS0+Y29udGV4dC5sZHQgKyAoc2VnICYgfjcpOwotCQliYXNlID0gKGRlc2NbMF0gPj4g
MTYpIHwgKChkZXNjWzFdICYgMHhmZikgPDwgMTYpIHwgKGRlc2NbMV0gJiAweGZmMDAwMDAwKTsK
KwkJc2VnICY9IH43VUw7CiAKLQkJLyogMTYtYml0IGNvZGUgc2VnbWVudD8gKi8KLQkJaWYgKCEo
KGRlc2NbMV0gPj4gMjIpICYgMSkpCi0JCQlhZGRyICY9IDB4ZmZmZjsKLQkJYWRkciArPSBiYXNl
OworCQlkb3duKCZjaGlsZC0+bW0tPmNvbnRleHQuc2VtKTsKKwkJaWYgKHVubGlrZWx5KChzZWcg
Pj4gMykgPj0gY2hpbGQtPm1tLT5jb250ZXh0LnNpemUpKQorCQkJYWRkciA9IC0xTDsgLyogYm9n
dXMgc2VsZWN0b3IsIGFjY2VzcyB3b3VsZCBmYXVsdCAqLworCQllbHNlIHsKKwkJCWRlc2MgPSBj
aGlsZC0+bW0tPmNvbnRleHQubGR0ICsgc2VnOworCQkJYmFzZSA9ICgoZGVzY1swXSA+PiAxNikg
fAorCQkJCSgoZGVzY1sxXSAmIDB4ZmYpIDw8IDE2KSB8CisJCQkJKGRlc2NbMV0gJiAweGZmMDAw
MDAwKSk7CisKKwkJCS8qIDE2LWJpdCBjb2RlIHNlZ21lbnQ/ICovCisJCQlpZiAoISgoZGVzY1sx
XSA+PiAyMikgJiAxKSkKKwkJCQlhZGRyICY9IDB4ZmZmZjsKKwkJCWFkZHIgKz0gYmFzZTsKKwkJ
fQogCQl1cCgmY2hpbGQtPm1tLT5jb250ZXh0LnNlbSk7CiAJfQorCiAJcmV0dXJuIGFkZHI7CiB9
CiAK
------=_Part_8106_7964408.1201562017911--

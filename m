Return-Path: <linux-kernel-owner+w=401wt.eu-S1764917AbYBBBfk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764917AbYBBBfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:35:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763974AbYBBBdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:33:52 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:28697 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763942AbYBBBdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:33:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=j43407L7FO7qHQT03cGgEAlEwHD/jgNttT0i3eNLlvT1keyRcBqltNLZp9YyFTjvSYEn/YwYgev8L6xvnY9s7lU4/AomOvWmcAUbv5LJPwZsvuIhR2JDXcP3KXVcn3BaOSvhfqvyH9H1TScHoHGd0U8+Hj+dnJiBSyxE4p5i5ec=
Message-ID: <6101e8c40802011733r40492c4fxa5ffd765504004fd@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:33:49 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {06/17} - handle-bogus-%cs-selector-in-single-step-instruction-decoding - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Roland McGrath" <roland@redhat.com>, "Jeff Mahoney" <jeffm@suse.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26263_7238891.1201916029755"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26263_7238891.1201916029755
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: 29eb51101c02df517ca64ec472d7501127ad1da8


-- 
Thanks,
Oliver

------=_Part_26263_7238891.1201916029755
Content-Type: message/rfc822;
 name=handle-bogus-%cs-selector-in-single-step-instruction-decoding
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=handle-bogus-%cs-selector-in-single-step-instruction-decoding


bCAyMDA3IDA4OjAzOjE2ICswMDAwICgtMDcwMCkKU3ViamVjdDogSGFuZGxlIGJvZ3VzICVjcyBz
ZWxlY3RvciBpbiBzaW5nbGUtc3RlcCBpbnN0cnVjdGlvbiBkZWNvZGluZwpQYXRjaC1tYWlubGlu
ZTogMi42LjIzLXJjMQpSZWZlcmVuY2VzOiAzMjYyNzAsIENWRS0yMDA3LTM3MzEKCkhhbmRsZSBi
b2d1cyAlY3Mgc2VsZWN0b3IgaW4gc2luZ2xlLXN0ZXAgaW5zdHJ1Y3Rpb24gZGVjb2RpbmcKClRo
ZSBjb2RlIGZvciBMRFQgc2VnbWVudCBzZWxlY3RvcnMgd2FzIG5vdCByb2J1c3QgaW4gdGhlIGZh
Y2Ugb2YgYSBib2d1cwpzZWxlY3RvciBzZXQgaW4gJWNzIHZpYSBwdHJhY2UgYmVmb3JlIHRoZSBz
aW5nbGUtc3RlcCB3YXMgZG9uZS4KClNpZ25lZC1vZmYtYnk6IFJvbGFuZCBNY0dyYXRoIDxyb2xh
bmRAcmVkaGF0LmNvbT4KU2lnbmVkLW9mZi1ieTogTGludXMgVG9ydmFsZHMgPHRvcnZhbGRzQGxp
bnV4LWZvdW5kYXRpb24ub3JnPgpBY2tlZC1ieTogSmVmZiBNYWhvbmV5IDxqZWZmbUBzdXNlLmNv
bT4KLS0tCgogYXJjaC9pMzg2L2tlcm5lbC9wdHJhY2UuYyAgIHwgICAyMiArKysrKysrKysrKysr
KystLS0tLS0tCiBhcmNoL3g4Nl82NC9rZXJuZWwvcHRyYWNlLmMgfCAgIDIzICsrKysrKysrKysr
KysrKystLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDMxIGluc2VydGlvbnMoKyksIDE0IGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvaTM4Ni9rZXJuZWwvcHRyYWNlLmMgYi9hcmNoL2kz
ODYva2VybmVsL3B0cmFjZS5jCmluZGV4IDFjMDc1ZjUuLjBjOGYwMGUgMTAwNjQ0Ci0tLSBhL2Fy
Y2gvaTM4Ni9rZXJuZWwvcHRyYWNlLmMKKysrIGIvYXJjaC9pMzg2L2tlcm5lbC9wdHJhY2UuYwpA
QCAtMTY0LDE0ICsxNjQsMjIgQEAgc3RhdGljIHVuc2lnbmVkIGxvbmcgY29udmVydF9laXBfdG9f
bGluZWFyKHN0cnVjdCB0YXNrX3N0cnVjdCAqY2hpbGQsIHN0cnVjdCBwdF8KIAkJdTMyICpkZXNj
OwogCQl1bnNpZ25lZCBsb25nIGJhc2U7CiAKLQkJZG93bigmY2hpbGQtPm1tLT5jb250ZXh0LnNl
bSk7Ci0JCWRlc2MgPSBjaGlsZC0+bW0tPmNvbnRleHQubGR0ICsgKHNlZyAmIH43KTsKLQkJYmFz
ZSA9IChkZXNjWzBdID4+IDE2KSB8ICgoZGVzY1sxXSAmIDB4ZmYpIDw8IDE2KSB8IChkZXNjWzFd
ICYgMHhmZjAwMDAwMCk7CisJCXNlZyAmPSB+N1VMOwogCi0JCS8qIDE2LWJpdCBjb2RlIHNlZ21l
bnQ/ICovCi0JCWlmICghKChkZXNjWzFdID4+IDIyKSAmIDEpKQotCQkJYWRkciAmPSAweGZmZmY7
Ci0JCWFkZHIgKz0gYmFzZTsKKwkJZG93bigmY2hpbGQtPm1tLT5jb250ZXh0LnNlbSk7CisJCWlm
ICh1bmxpa2VseSgoc2VnID4+IDMpID49IGNoaWxkLT5tbS0+Y29udGV4dC5zaXplKSkKKwkJCWFk
ZHIgPSAtMUw7IC8qIGJvZ3VzIHNlbGVjdG9yLCBhY2Nlc3Mgd291bGQgZmF1bHQgKi8KKwkJZWxz
ZSB7CisJCQlkZXNjID0gY2hpbGQtPm1tLT5jb250ZXh0LmxkdCArIHNlZzsKKwkJCWJhc2UgPSAo
KGRlc2NbMF0gPj4gMTYpIHwKKwkJCQkoKGRlc2NbMV0gJiAweGZmKSA8PCAxNikgfAorCQkJCShk
ZXNjWzFdICYgMHhmZjAwMDAwMCkpOworCisJCQkvKiAxNi1iaXQgY29kZSBzZWdtZW50PyAqLwor
CQkJaWYgKCEoKGRlc2NbMV0gPj4gMjIpICYgMSkpCisJCQkJYWRkciAmPSAweGZmZmY7CisJCQlh
ZGRyICs9IGJhc2U7CisJCX0KIAkJdXAoJmNoaWxkLT5tbS0+Y29udGV4dC5zZW0pOwogCX0KIAly
ZXR1cm4gYWRkcjsKZGlmZiAtLWdpdCBhL2FyY2gveDg2XzY0L2tlcm5lbC9wdHJhY2UuYyBiL2Fy
Y2gveDg2XzY0L2tlcm5lbC9wdHJhY2UuYwppbmRleCBmYTY3NzVlLi5lODNjYzY3IDEwMDY0NAot
LS0gYS9hcmNoL3g4Nl82NC9rZXJuZWwvcHRyYWNlLmMKKysrIGIvYXJjaC94ODZfNjQva2VybmVs
L3B0cmFjZS5jCkBAIC0xMDIsMTYgKzEwMiwyNSBAQCB1bnNpZ25lZCBsb25nIGNvbnZlcnRfcmlw
X3RvX2xpbmVhcihzdHJ1Y3QgdGFza19zdHJ1Y3QgKmNoaWxkLCBzdHJ1Y3QgcHRfcmVncyAqcgog
CQl1MzIgKmRlc2M7CiAJCXVuc2lnbmVkIGxvbmcgYmFzZTsKIAotCQlkb3duKCZjaGlsZC0+bW0t
PmNvbnRleHQuc2VtKTsKLQkJZGVzYyA9IGNoaWxkLT5tbS0+Y29udGV4dC5sZHQgKyAoc2VnICYg
fjcpOwotCQliYXNlID0gKGRlc2NbMF0gPj4gMTYpIHwgKChkZXNjWzFdICYgMHhmZikgPDwgMTYp
IHwgKGRlc2NbMV0gJiAweGZmMDAwMDAwKTsKKwkJc2VnICY9IH43VUw7CiAKLQkJLyogMTYtYml0
IGNvZGUgc2VnbWVudD8gKi8KLQkJaWYgKCEoKGRlc2NbMV0gPj4gMjIpICYgMSkpCi0JCQlhZGRy
ICY9IDB4ZmZmZjsKLQkJYWRkciArPSBiYXNlOworCQlkb3duKCZjaGlsZC0+bW0tPmNvbnRleHQu
c2VtKTsKKwkJaWYgKHVubGlrZWx5KChzZWcgPj4gMykgPj0gY2hpbGQtPm1tLT5jb250ZXh0LnNp
emUpKQorCQkJYWRkciA9IC0xTDsgLyogYm9ndXMgc2VsZWN0b3IsIGFjY2VzcyB3b3VsZCBmYXVs
dCAqLworCQllbHNlIHsKKwkJCWRlc2MgPSBjaGlsZC0+bW0tPmNvbnRleHQubGR0ICsgc2VnOwor
CQkJYmFzZSA9ICgoZGVzY1swXSA+PiAxNikgfAorCQkJCSgoZGVzY1sxXSAmIDB4ZmYpIDw8IDE2
KSB8CisJCQkJKGRlc2NbMV0gJiAweGZmMDAwMDAwKSk7CisKKwkJCS8qIDE2LWJpdCBjb2RlIHNl
Z21lbnQ/ICovCisJCQlpZiAoISgoZGVzY1sxXSA+PiAyMikgJiAxKSkKKwkJCQlhZGRyICY9IDB4
ZmZmZjsKKwkJCWFkZHIgKz0gYmFzZTsKKwkJfQogCQl1cCgmY2hpbGQtPm1tLT5jb250ZXh0LnNl
bSk7CiAJfQorCiAJcmV0dXJuIGFkZHI7CiB9CiAK
------=_Part_26263_7238891.1201916029755--

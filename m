Return-Path: <linux-kernel-owner+w=401wt.eu-S1763563AbYA1XTi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763563AbYA1XTi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:19:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764268AbYA1XOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:14:01 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:42115 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764392AbYA1XN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:13:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=PJrrTybEb3fLiWCkHUIlke9cPzj7IetppEEXSpIOmggEg1a+5YOHCZabjitgTId2SGAsPMfr3yAOCHT/wZlVYDmYEy26oDNcknYRXL5kOVKZuEt8KkEulh6TZ9C/VBVKWOe3ropcCoUS9/YXaIgO4MDWdBX7UJjwUmN+uS3e/EM=
Message-ID: <6101e8c40801281513g5b8cc722y1066422326cb4a2@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:13:57 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {12/17} - nfsacl-retval.diff - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       Roland <devzero@web.de>, "Andreas Gruenbacher" <agruen@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8119_30214657.1201562037323"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8119_30214657.1201562037323
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8119_30214657.1201562037323
Content-Type: text/x-diff; name=nfsacl-retval.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfsacl-retval.diff

Y29tbWl0IDU3M2ZhN2I4ZjIwM2I3ZjE0ZDE4NGIwZDcwMGJmOTc4ZWUyNzVlZWMKQXV0aG9yOiBK
LiBCcnVjZSBGaWVsZHMgPGJmaWVsZHNAY2l0aS51bWljaC5lZHU+CkRhdGU6ICAgRnJpIE5vdiAy
IDE1OjM2OjA4IDIwMDcgLTA0MDAKCiAgICBTdWJqZWN0OiBbUEFUQ0hdIGtuZnNkOiBmaXggc3B1
cmlvdXMgRUlOVkFMIGVycm9ycyBvbiBmaXJzdCBhY2Nlc3Mgb2YgbmV3IGZpbGVzeXN0ZW0KICAg
IFJlZmVyZW5jZXM6IDM0MDg3MwogICAgCiAgICBUaGUgdjIvdjMgYWNsIGNvZGUgaW4gbmZzZCBp
cyB0cmFuc2xhdGluZyBhbnkgcmV0dXJuIGZyb20gZmhfdmVyaWZ5KCkgdG8KICAgIG5mc2Vycl9p
bnZhbC4gIFRoaXMgaXMgcGFydGljdWxhcmx5IHVuZm9ydHVuYXRlIGluIHRoZSBjYXNlIG9mIGFu
CiAgICBuZnNlcnJfZHJvcGl0IHJldHVybiwgd2hpY2ggaXMgYW4gaW50ZXJuYWwgZXJyb3IgbWVh
bnQgdG8gaW5kaWNhdGUgdG8KICAgIGNhbGxlcnMgdGhhdCB0aGlzIHJlcXVlc3QgaGFzIGJlZW4g
ZGVmZXJyZWQgYW5kIHNob3VsZCBqdXN0IGJlIGRyb3BwZWQKICAgIHBlbmRpbmcgdGhlIHJlc3Vs
dHMgb2YgYW4gdXBjYWxsIHRvIG1vdW50ZC4KICAgIAogICAgVGhhbmtzIHRvIFJvbGFuZCA8ZGV2
emVyb0B3ZWIuZGU+IGZvciBidWcgcmVwb3J0IGFuZCBkYXRhIGNvbGxlY3Rpb24uCiAgICAKICAg
IENjOiBSb2xhbmQgPGRldnplcm9Ad2ViLmRlPgogICAgQWNrZWQtYnk6IEFuZHJlYXMgR3J1ZW5i
YWNoZXIgPGFncnVlbkBzdXNlLmRlPgogICAgU2lnbmVkLW9mZi1ieTogSi4gQnJ1Y2UgRmllbGRz
IDxiZmllbGRzQGNpdGkudW1pY2guZWR1PgoKZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzMmFjbC5j
IGIvZnMvbmZzZC9uZnMyYWNsLmMKaW5kZXggYjYxNzQyOC4uMGU1ZmExMSAxMDA2NDQKLS0tIGEv
ZnMvbmZzZC9uZnMyYWNsLmMKKysrIGIvZnMvbmZzZC9uZnMyYWNsLmMKQEAgLTQxLDcgKzQxLDcg
QEAgc3RhdGljIF9fYmUzMiBuZnNhY2xkX3Byb2NfZ2V0YWNsKHN0cnVjdCBzdmNfcnFzdCAqIHJx
c3RwLAogCiAJZmggPSBmaF9jb3B5KCZyZXNwLT5maCwgJmFyZ3AtPmZoKTsKIAlpZiAoKG5mc2Vy
ciA9IGZoX3ZlcmlmeShycXN0cCwgJnJlc3AtPmZoLCAwLCBNQVlfTk9QKSkpCi0JCVJFVFVSTl9T
VEFUVVMobmZzZXJyX2ludmFsKTsKKwkJUkVUVVJOX1NUQVRVUyhuZnNlcnIpOwogCiAJaWYgKGFy
Z3AtPm1hc2sgJiB+KE5GU19BQ0x8TkZTX0FDTENOVHxORlNfREZBQ0x8TkZTX0RGQUNMQ05UKSkK
IAkJUkVUVVJOX1NUQVRVUyhuZnNlcnJfaW52YWwpOwpkaWZmIC0tZ2l0IGEvZnMvbmZzZC9uZnMz
YWNsLmMgYi9mcy9uZnNkL25mczNhY2wuYwppbmRleCAzZTNmMmRlLi5iNjQ3ZjJmIDEwMDY0NAot
LS0gYS9mcy9uZnNkL25mczNhY2wuYworKysgYi9mcy9uZnNkL25mczNhY2wuYwpAQCAtMzcsNyAr
MzcsNyBAQCBzdGF0aWMgX19iZTMyIG5mc2QzX3Byb2NfZ2V0YWNsKHN0cnVjdCBzdmNfcnFzdCAq
IHJxc3RwLAogCiAJZmggPSBmaF9jb3B5KCZyZXNwLT5maCwgJmFyZ3AtPmZoKTsKIAlpZiAoKG5m
c2VyciA9IGZoX3ZlcmlmeShycXN0cCwgJnJlc3AtPmZoLCAwLCBNQVlfTk9QKSkpCi0JCVJFVFVS
Tl9TVEFUVVMobmZzZXJyX2ludmFsKTsKKwkJUkVUVVJOX1NUQVRVUyhuZnNlcnIpOwogCiAJaWYg
KGFyZ3AtPm1hc2sgJiB+KE5GU19BQ0x8TkZTX0FDTENOVHxORlNfREZBQ0x8TkZTX0RGQUNMQ05U
KSkKIAkJUkVUVVJOX1NUQVRVUyhuZnNlcnJfaW52YWwpOwo=
------=_Part_8119_30214657.1201562037323--

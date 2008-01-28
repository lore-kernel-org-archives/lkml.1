Return-Path: <linux-kernel-owner+w=401wt.eu-S1765131AbYA1XVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765131AbYA1XVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764405AbYA1XOP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 18:14:15 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:43907 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764347AbYA1XOJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 18:14:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=h04km3GVdsRVH8401KPW6J0hgx2HxFjtRmdoVDccfG6d24LywfrNWLuHoNlPHOg7GevVK5CareNlsLoXEhDBakpBYz8ZkbxGs4Itag5X9i6QO4s11NJpGglqm2UlhCV4EBIWXzaB1ln1H0fsUqPXHefsvzJmscM/IzOd4ODzKLw=
Message-ID: <6101e8c40801281514w75999e05ld5ec6583d37e340d@mail.gmail.com>
Date: Tue, 29 Jan 2008 00:14:08 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {16/17} - nfsv4-MAXNAME-fix.diff - series for stable kernel
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_8129_21337901.1201562048631"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_8129_21337901.1201562048631
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
Thanks,
Oliver

------=_Part_8129_21337901.1201562048631
Content-Type: text/x-diff; name=nfsv4-MAXNAME-fix.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: file1
Content-Disposition: attachment; filename=nfsv4-MAXNAME-fix.diff

Y29tbWl0IDQxN2Y4MDgwYTM4MTQzYmQxNWVjYTE1YjZjYzM5NzRiMDk5YzNhMjgKQXV0aG9yOiBK
LiBCcnVjZSBGaWVsZHMgPGJmaWVsZHNAY2l0aS51bWljaC5lZHU+CkRhdGU6ICAgRnJpIFNlcCAy
OCAxNjo0NTo1MSAyMDA3IC0wNDAwCgogICAgU3ViamVjdDoga25mc2Q6IHF1ZXJ5IGZpbGVzeXN0
ZW0gZm9yIE5GU3Y0IGdldGF0dHIgb2YgRkFUVFI0X01BWE5BTUUKICAgIFJlZmVyZW5jZXM6IDI3
MTgwMwogICAgUGF0Y2gtbWFpbmxpbmU6IDIuNi4yNCAobGlrZWx5KQogICAgCiAgICBXaXRob3V0
IHRoaXMgd2UgYWx3YXlzIHJldHVybiAyXjMyLTEgYXMgdGhlIHRoZSBtYXhpbXVtIG5hbWVsZW5n
dGguCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6IEouIEJydWNlIEZpZWxkcyA8YmZpZWxkc0BjaXRp
LnVtaWNoLmVkdT4KICAgIFNpZ25lZC1vZmYtYnk6IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVl
bkBzdXNlLmRlPgoKZGlmZiAtLWdpdCBhL2ZzL25mc2QvbmZzNHhkci5jIGIvZnMvbmZzZC9uZnM0
eGRyLmMKaW5kZXggMTU4MDlkZi4uMDg5OGFlYyAxMDA2NDQKLS0tIGEvZnMvbmZzZC9uZnM0eGRy
LmMKKysrIGIvZnMvbmZzZC9uZnM0eGRyLmMKQEAgLTE0NTMsNyArMTQ1Myw4IEBAIG5mc2Q0X2Vu
Y29kZV9mYXR0cihzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIHN0cnVjdCBzdmNfZXhwb3J0ICpleHAsCiAJ
ZXJyID0gdmZzX2dldGF0dHIoZXhwLT5leF9tbnQsIGRlbnRyeSwgJnN0YXQpOwogCWlmIChlcnIp
CiAJCWdvdG8gb3V0X25mc2VycjsKLQlpZiAoKGJtdmFsMCAmIChGQVRUUjRfV09SRDBfRklMRVNf
RlJFRSB8IEZBVFRSNF9XT1JEMF9GSUxFU19UT1RBTCkpIHx8CisJaWYgKChibXZhbDAgJiAoRkFU
VFI0X1dPUkQwX0ZJTEVTX0ZSRUUgfCBGQVRUUjRfV09SRDBfRklMRVNfVE9UQUwgfAorCQkJRkFU
VFI0X1dPUkQwX01BWE5BTUUpKSB8fAogCSAgICAoYm12YWwxICYgKEZBVFRSNF9XT1JEMV9TUEFD
RV9BVkFJTCB8IEZBVFRSNF9XT1JEMV9TUEFDRV9GUkVFIHwKIAkJICAgICAgIEZBVFRSNF9XT1JE
MV9TUEFDRV9UT1RBTCkpKSB7CiAJCWVyciA9IHZmc19zdGF0ZnMoZGVudHJ5LCAmc3RhdGZzKTsK
QEAgLTE2OTksNyArMTcwMCw3IEBAIG91dF9hY2w6CiAJaWYgKGJtdmFsMCAmIEZBVFRSNF9XT1JE
MF9NQVhOQU1FKSB7CiAJCWlmICgoYnVmbGVuIC09IDQpIDwgMCkKIAkJCWdvdG8gb3V0X3Jlc291
cmNlOwotCQlXUklURTMyKH4odTMyKSAwKTsKKwkJV1JJVEUzMihzdGF0ZnMuZl9uYW1lbGVuKTsK
IAl9CiAJaWYgKGJtdmFsMCAmIEZBVFRSNF9XT1JEMF9NQVhSRUFEKSB7CiAJCWlmICgoYnVmbGVu
IC09IDgpIDwgMCkK
------=_Part_8129_21337901.1201562048631--

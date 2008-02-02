Return-Path: <linux-kernel-owner+w=401wt.eu-S1765401AbYBBBjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765401AbYBBBjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764332AbYBBBep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:34:45 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764275AbYBBBem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:34:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=YBA2d5pbacR7uJa6kbfS/fRvw8PrVOqyqKbR+XDIQBtKHM3IuL/2GHsX8O48LRHh+f3EPb1AixhnNYQ7WJjrn6SroqKdjhccvPI/Oa84/g1QqIoBurqgT6jOpLIuSuz7MXlJcFlDFvSbcpG4n1pK6DRDnMuc28OcY/qJ1fprxcI=
Message-ID: <6101e8c40802011734t235bc7j88a5f3fb6227aaf4@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:34:41 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {16/17} - nfsv4-MAXNAME-fix.diff - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Andreas Gruenbacher" <agruen@suse.de>,
       "J. Bruce Fields" <bfields@citi.umich.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26283_28874416.1201916081974"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26283_28874416.1201916081974
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: a16e92edcd0a2846455a30823e1bac964e743baa


-- 
Thanks,
Oliver

------=_Part_26283_28874416.1201916081974
Content-Type: text/x-diff; name=nfsv4-MAXNAME-fix.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment; filename=nfsv4-MAXNAME-fix.diff

RnJvbTogSi4gQnJ1Y2UgRmllbGRzIDxiZmllbGRzQGNpdGkudW1pY2guZWR1PgpEYXRlOiBGcmks
IDI4IFNlcCAyMDA3IDE2OjQ1OjUxIC0wNDAwClN1YmplY3Q6IGtuZnNkOiBxdWVyeSBmaWxlc3lz
dGVtIGZvciBORlN2NCBnZXRhdHRyIG9mIEZBVFRSNF9NQVhOQU1FClJlZmVyZW5jZXM6IDI3MTgw
MwpQYXRjaC1tYWlubGluZTogMi42LjI0IChsaWtlbHkpCgpXaXRob3V0IHRoaXMgd2UgYWx3YXlz
IHJldHVybiAyXjMyLTEgYXMgdGhlIHRoZSBtYXhpbXVtIG5hbWVsZW5ndGguCgpTaWduZWQtb2Zm
LWJ5OiBKLiBCcnVjZSBGaWVsZHMgPGJmaWVsZHNAY2l0aS51bWljaC5lZHU+ClNpZ25lZC1vZmYt
Ynk6IEFuZHJlYXMgR3J1ZW5iYWNoZXIgPGFncnVlbkBzdXNlLmRlPgoKLS0tCiBmcy9uZnNkL25m
czR4ZHIuYyB8ICAgIDUgKysrLS0KIDEgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQoKLS0tIGxpbnV4LTIuNi4yMi5vcmlnL2ZzL25mc2QvbmZzNHhkci5jCisr
KyBsaW51eC0yLjYuMjIvZnMvbmZzZC9uZnM0eGRyLmMKQEAgLTE0NTMsNyArMTQ1Myw4IEBAIG5m
c2Q0X2VuY29kZV9mYXR0cihzdHJ1Y3Qgc3ZjX2ZoICpmaHAsIHMKIAllcnIgPSB2ZnNfZ2V0YXR0
cihleHAtPmV4X21udCwgZGVudHJ5LCAmc3RhdCk7CiAJaWYgKGVycikKIAkJZ290byBvdXRfbmZz
ZXJyOwotCWlmICgoYm12YWwwICYgKEZBVFRSNF9XT1JEMF9GSUxFU19GUkVFIHwgRkFUVFI0X1dP
UkQwX0ZJTEVTX1RPVEFMKSkgfHwKKwlpZiAoKGJtdmFsMCAmIChGQVRUUjRfV09SRDBfRklMRVNf
RlJFRSB8IEZBVFRSNF9XT1JEMF9GSUxFU19UT1RBTCB8CisJCQlGQVRUUjRfV09SRDBfTUFYTkFN
RSkpIHx8CiAJICAgIChibXZhbDEgJiAoRkFUVFI0X1dPUkQxX1NQQUNFX0FWQUlMIHwgRkFUVFI0
X1dPUkQxX1NQQUNFX0ZSRUUgfAogCQkgICAgICAgRkFUVFI0X1dPUkQxX1NQQUNFX1RPVEFMKSkp
IHsKIAkJZXJyID0gdmZzX3N0YXRmcyhkZW50cnksICZzdGF0ZnMpOwpAQCAtMTY5OSw3ICsxNzAw
LDcgQEAgb3V0X2FjbDoKIAlpZiAoYm12YWwwICYgRkFUVFI0X1dPUkQwX01BWE5BTUUpIHsKIAkJ
aWYgKChidWZsZW4gLT0gNCkgPCAwKQogCQkJZ290byBvdXRfcmVzb3VyY2U7Ci0JCVdSSVRFMzIo
fih1MzIpIDApOworCQlXUklURTMyKHN0YXRmcy5mX25hbWVsZW4pOwogCX0KIAlpZiAoYm12YWww
ICYgRkFUVFI0X1dPUkQwX01BWFJFQUQpIHsKIAkJaWYgKChidWZsZW4gLT0gOCkgPCAwKQo=
------=_Part_26283_28874416.1201916081974--

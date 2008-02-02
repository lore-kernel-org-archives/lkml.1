Return-Path: <linux-kernel-owner+w=401wt.eu-S932109AbYBBBgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbYBBBgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 20:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764121AbYBBBeT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 20:34:19 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:28811 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764100AbYBBBeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 20:34:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=Hk/zwvdLAN2zLwBvb1bhstgS3YQqgIkI+3vsVCmB57T/CojwPUSc68GfFcPPeV/o8CjO3Gd8YS9S9AHeU7mLN8NXIibXL7JnC7MIs1uyCFAMBq5YES7j1RazzazDheJchX0Zzpyj5k18n5U/KhjN6TdBxrSTU0M6TprKs0XvlD0=
Message-ID: <6101e8c40802011734v57f59e99o18c66db3bc7a15e0@mail.gmail.com>
Date: Sat, 2 Feb 2008 02:34:16 +0100
From: "=?ISO-8859-1?Q?Oliver_Pinter_(Pint=E9r_Oliv=E9r)?=" 
	<oliver.pntr@gmail.com>
To: "Linux Kernel" <linux-kernel@vger.kernel.org>, stable@kernel.org,
       stable-commits@vger.kernel.org
Subject: [2.6.22.y] {10/17} - via-velocity-dont-oops-on-mtu-change-1 - series for stable kernel #2
Cc: "chrisw@sous-sol.org" <chrisw@sous-sol.org>, "Greg KH" <gregkh@suse.de>,
       "Willy Tarreau" <w@1wt.eu>, "Adrian Bunk" <bunk@kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>,
       "Jeff Garzik" <jeff@garzik.org>, "Jeff Mahoney" <jeffm@suse.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_26271_16633580.1201916056486"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_26271_16633580.1201916056486
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

mainline: bd7b3f34198071d8bec05180530c362f1800ba46


-- 
Thanks,
Oliver

------=_Part_26271_16633580.1201916056486
Content-Type: message/rfc822; name=via-velocity-dont-oops-on-mtu-change-1
Content-Transfer-Encoding: base64
X-Attachment-Id: file0
Content-Disposition: attachment;
 filename=via-velocity-dont-oops-on-mtu-change-1


CkRhdGU6IFRodSwgMTUgTm92IDIwMDcgMDM6NDc6MjcgKzAwMDAgKC0wODAwKQpTdWJqZWN0OiBb
VklBX1ZFTE9DSVRZXTogRG9uJ3Qgb29wcyBvbiBNVFUgY2hhbmdlLgpQYXRjaC1tYWlubGluZTog
djIuNi4yNC1yYzMKUmVmZXJlbmNlczogMzQxNTM3CgpbVklBX1ZFTE9DSVRZXTogRG9uJ3Qgb29w
cyBvbiBNVFUgY2hhbmdlLgoKU2ltcGxlIG10dSBjaGFuZ2Ugd2hlbiBkZXZpY2UgaXMgZG93bi4K
Rml4IGh0dHA6Ly9idWd6aWxsYS5rZXJuZWwub3JnL3Nob3dfYnVnLmNnaT9pZD05MzgyLgoKU2ln
bmVkLW9mZi1ieTogU3RlcGhlbiBIZW1taW5nZXIgPHNoZW1taW5nZXJAbGludXgtZm91bmRhdGlv
bi5vcmc+ClNpZ25lZC1vZmYtYnk6IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5l
dD4KQWNrZWQtYnk6IEplZmYgTWFob25leSA8amVmZm1Ac3VzZS5jb20+Ci0tLQogZHJpdmVycy9u
ZXQvdmlhLXZlbG9jaXR5LmMgfCAgICA1ICsrKysrCiAxIGZpbGUgY2hhbmdlZCwgNSBpbnNlcnRp
b25zKCspCgotLS0gYS9kcml2ZXJzL25ldC92aWEtdmVsb2NpdHkuYwkyMDA4LTAxLTAzIDE1OjE4
OjM1LjAwMDAwMDAwMCAtMDUwMAorKysgYi9kcml2ZXJzL25ldC92aWEtdmVsb2NpdHkuYwkyMDA4
LTAxLTAzIDE1OjE4OjUwLjAwMDAwMDAwMCAtMDUwMApAQCAtMTc5OCw2ICsxNzk4LDExIEBAIHN0
YXRpYyBpbnQgdmVsb2NpdHlfY2hhbmdlX210dShzdHJ1Y3QgbmUKIAkJcmV0dXJuIC1FSU5WQUw7
CiAJfQogCisJaWYgKCFuZXRpZl9ydW5uaW5nKGRldikpIHsKKwkJZGV2LT5tdHUgPSBuZXdfbXR1
OworCQlyZXR1cm4gMDsKKwl9CisKIAlpZiAobmV3X210dSAhPSBvbGRtdHUpIHsKIAkJc3Bpbl9s
b2NrX2lycXNhdmUoJnZwdHItPmxvY2ssIGZsYWdzKTsKIAo=
------=_Part_26271_16633580.1201916056486--

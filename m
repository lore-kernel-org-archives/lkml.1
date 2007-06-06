Return-Path: <linux-kernel-owner+w=401wt.eu-S1760675AbXFFESP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760675AbXFFESP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 00:18:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbXFFESB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 00:18:01 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:38947 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXFFESA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 00:18:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type;
        b=PIP1dc1J808VKxXJUmZ4FdSGgW0vS3UQ26hNhzsn4gzEQGHGBLMgPkIhgpXHDZ16rxaNhl/Ga1KWIJGCzoFR5twurlkIQwIZAWYwqT5oRtHND3im+1n9sBl44G/ItZ7f1ZWF2CcohW68QDuL7W25pMfx5BkUYIjpl91sD5oeSYQ=
Message-ID: <86802c440706052117i57b86f84p1d5be56be690c934@mail.gmail.com>
Date: Tue, 5 Jun 2007 21:17:54 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: [PATCH] x86_64: remove extra extern declaring about dmi_ioremap
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_37032_20526330.1181103474779"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_37032_20526330.1181103474779
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

[PATCH] x86_64: remove extra extern declaring about dmi_ioremap

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

------=_Part_37032_20526330.1181103474779
Content-Type: text/x-patch; name=6x.diff; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f2lb1vq4
Content-Disposition: attachment; filename="6x.diff"

CmRpZmYgLS1naXQgYS9pbmNsdWRlL2FzbS14ODZfNjQvZG1pLmggYi9pbmNsdWRlL2FzbS14ODZf
NjQvZG1pLmgKaW5kZXggOTNiMmIxNS4uZmM3YjU3NiAxMDA2NDQKLS0tIGEvaW5jbHVkZS9hc20t
eDg2XzY0L2RtaS5oCisrKyBiL2luY2x1ZGUvYXNtLXg4Nl82NC9kbWkuaApAQCAtMywxNSArMywx
MiBAQAogCiAjaW5jbHVkZSA8YXNtL2lvLmg+CiAKLWV4dGVybiB2b2lkICpkbWlfaW9yZW1hcCh1
bnNpZ25lZCBsb25nIGFkZHIsIHVuc2lnbmVkIGxvbmcgc2l6ZSk7Ci1leHRlcm4gdm9pZCBkbWlf
aW91bm1hcCh2b2lkICphZGRyLCB1bnNpZ25lZCBsb25nIHNpemUpOwotCiAjZGVmaW5lIERNSV9N
QVhfREFUQSAyMDQ4CiAKIGV4dGVybiBpbnQgZG1pX2FsbG9jX2luZGV4OwogZXh0ZXJuIGNoYXIg
ZG1pX2FsbG9jX2RhdGFbRE1JX01BWF9EQVRBXTsKIAotLyogVGhpcyBpcyBzbyBlYXJseSB0aGF0
IHRoZXJlIGlzIG5vIGdvb2Qgd2F5IHRvIGFsbG9jYXRlIGR5bmFtaWMgbWVtb3J5LiAKKy8qIFRo
aXMgaXMgc28gZWFybHkgdGhhdCB0aGVyZSBpcyBubyBnb29kIHdheSB0byBhbGxvY2F0ZSBkeW5h
bWljIG1lbW9yeS4KICAgIEFsbG9jYXRlIGRhdGEgaW4gYW4gQlNTIGFycmF5LiAqLwogc3RhdGlj
IGlubGluZSB2b2lkICpkbWlfYWxsb2ModW5zaWduZWQgbGVuKQogewo=
------=_Part_37032_20526330.1181103474779--

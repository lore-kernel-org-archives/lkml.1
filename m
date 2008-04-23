Return-Path: <linux-kernel-owner+w=401wt.eu-S1755230AbYDWLeS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbYDWLeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbYDWLeE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:34:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:11392 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750827AbYDWLeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:34:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=kIYxHap4YiDDiyGadt2BXdbxEqqxLPkd47CROpz/VbkRTLd/DkRPM3RH2tvDkaUuYYd1zOkp6XXSMqD+6mvae1CbEJYkoGmgNCJMA+RjlrdeSaEkKouFGVRG+HKiu8IACgynN407Bv7tu5uiiGZIG4HhslAab6mzjo1AmioEUu0=
Message-ID: <eb3ff54b0804230434m5a844cf9w4b2ee074bce832c0@mail.gmail.com>
Date: Wed, 23 Apr 2008 14:34:00 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] [IPV6] Remove unused macro (MLDV2_QQIC) from mcast.c.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13625_18153997.1208950440762"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13625_18153997.1208950440762
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
This patch removes  MLDV2_QQIC macro from mcast.c
as it is unused.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_13625_18153997.1208950440762
Content-Type: text/plain; name=patch1.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffdtshci0
Content-Disposition: attachment; filename=patch1.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L21jYXN0LmMgYi9uZXQvaXB2Ni9tY2FzdC5jCmluZGV4IDU0
ZjkxZWYuLmJmZjk5ZmIgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L21jYXN0LmMKKysrIGIvbmV0L2lw
djYvbWNhc3QuYwpAQCAtMTY0LDcgKzE2NCw2IEBAIHN0YXRpYyBpbnQgaXA2X21jX2xlYXZlX3Ny
YyhzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdCBpcHY2X21jX3NvY2tsaXN0ICppbWwsCiAJKChNTERW
Ml9NQVNLKHZhbHVlLCBuYm1hbnQpIHwgKDE8PChuYm1hbnQpKSkgPDwgXAogCShNTERWMl9NQVNL
KCh2YWx1ZSkgPj4gKG5ibWFudCksIG5iZXhwKSArIChuYmV4cCkpKSkKIAotI2RlZmluZSBNTERW
Ml9RUUlDKHZhbHVlKSBNTERWMl9FWFAoMHg4MCwgNCwgMywgdmFsdWUpCiAjZGVmaW5lIE1MRFYy
X01SQyh2YWx1ZSkgTUxEVjJfRVhQKDB4ODAwMCwgMTIsIDMsIHZhbHVlKQogCiAjZGVmaW5lIElQ
VjZfTUxEX01BWF9NU0YJNjQK
------=_Part_13625_18153997.1208950440762--

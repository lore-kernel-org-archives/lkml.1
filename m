Return-Path: <linux-kernel-owner+w=401wt.eu-S1756004AbYDWLfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004AbYDWLfa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 07:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbYDWLfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 07:35:16 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13233 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308AbYDWLfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 07:35:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=DFFNBang/cRqeyuho5MD5h7LuViptWzMKEStFvnnV01BACniXk+cNUP4uQpPq8IIG13SvK3lXYCo+jcEYaKwi/LRdKDWPxA+KxI7hs6G3Df/QiUnZKRpR6CAOkCMeg6mTOLRkCq5NdeekFEoa5a5IEMHKvAfygkJ+95UOmcOw9M=
Message-ID: <eb3ff54b0804230435y2060d8c8pcaa9d5b806e309f4@mail.gmail.com>
Date: Wed, 23 Apr 2008 14:35:13 +0300
From: "Rami Rosen" <ramirose@gmail.com>
To: yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] [IPV6] Use MRT6_VERSION instead of MRT_VERSION in ip6mr.c.
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_13630_5449911.1208950513838"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_13630_5449911.1208950513838
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
MRT6_VERSION should be used instead of MRT_VERSION in ip6mr.c.

Regards,
Rami Rosen


Signed-off-by: Rami Rosen <ramirose@gmail.com>

------=_Part_13630_5449911.1208950513838
Content-Type: text/plain; name=patch2.txt
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ffdtvgzj0
Content-Disposition: attachment; filename=patch2.txt

ZGlmZiAtLWdpdCBhL25ldC9pcHY2L2lwNm1yLmMgYi9uZXQvaXB2Ni9pcDZtci5jCmluZGV4IGM4
YzZlMzMuLjhhYmZmN2UgMTAwNjQ0Ci0tLSBhL25ldC9pcHY2L2lwNm1yLmMKKysrIGIvbmV0L2lw
djYvaXA2bXIuYwpAQCAtMTI0OCw3ICsxMjQ4LDcgQEAgaW50IGlwNl9tcm91dGVfc2V0c29ja29w
dChzdHJ1Y3Qgc29jayAqc2ssIGludCBvcHRuYW1lLCBjaGFyIF9fdXNlciAqb3B0dmFsLCBpbnQK
IAogI2VuZGlmCiAJLyoKLQkgKglTcHVyaW91cyBjb21tYW5kLCBvciBNUlRfVkVSU0lPTiB3aGlj
aCB5b3UgY2Fubm90CisJICoJU3B1cmlvdXMgY29tbWFuZCwgb3IgTVJUNl9WRVJTSU9OIHdoaWNo
IHlvdSBjYW5ub3QKIAkgKglzZXQuCiAJICovCiAJZGVmYXVsdDoK
------=_Part_13630_5449911.1208950513838--

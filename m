Return-Path: <linux-kernel-owner+w=401wt.eu-S1756621AbYKEUgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbYKEUgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757301AbYKEUgi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:36:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:16331 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768AbYKEUgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:36:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type;
        b=JKnQBfYv+b6jC7eHNyRAdUTPBvWPEAX1umXKmiPACcQlz58AiY0pcWrSV3EWWGTwDO
         CVjLrJ9zg3b9A6IhguQgDZuvTT1W+LkYC4JFQjzLGPOAYuOSHzBlTb5NQqRi2ci71Hqz
         hCwEQsWKrGhfzIJHuzrKEUyafffvdS32UWGXg=
Message-ID: <cd73a99e0811051236x3c852ce7w5d16a695d8efb9c6@mail.gmail.com>
Date: Wed, 5 Nov 2008 22:36:35 +0200
From: "Andrew Victor" <avictor.za@gmail.com>
To: wim@iguana.be, "Andrew Morton" <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] SAM9 watchdog - supported on all SAM9 and CAP9 processors
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_32765_7117469.1225917395505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_32765_7117469.1225917395505
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

The SAM9 watchdog driver is usable on the whole family of AT91SAM9 and
CAP9 processors.
Update the configuration to indicate this and allow the driver to be selected.

Signed-off-by: Andrew Victor <linux@maxim.org.za>

------=_Part_32765_7117469.1225917395505
Content-Type: text/x-patch; name=sam9_wdt_config.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fn6f507u1
Content-Disposition: attachment; filename=sam9_wdt_config.patch

ZGlmZiAtdXJOIC14IENWUyBsaW51eC0yLjYuMjgtcmMzL2RyaXZlcnMvd2F0Y2hkb2cvS2NvbmZp
ZyBsaW51eC0yLjYvZHJpdmVycy93YXRjaGRvZy9LY29uZmlnCi0tLSBsaW51eC0yLjYuMjgtcmMz
L2RyaXZlcnMvd2F0Y2hkb2cvS2NvbmZpZwkyMDA4LTExLTA1IDIyOjIxOjAxLjAwMDAwMDAwMCAr
MDIwMAorKysgbGludXgtMi42L2RyaXZlcnMvd2F0Y2hkb2cvS2NvbmZpZwkyMDA4LTExLTA1IDIy
OjIzOjA3LjAwMDAwMDAwMCArMDIwMApAQCAtNjcsMTEgKzY3LDExIEBACiAJICBzeXN0ZW0gd2hl
biB0aGUgdGltZW91dCBpcyByZWFjaGVkLgogCiBjb25maWcgQVQ5MVNBTTlYX1dBVENIRE9HCi0J
dHJpc3RhdGUgIkFUOTFTQU05WCB3YXRjaGRvZyIKLQlkZXBlbmRzIG9uIFdBVENIRE9HICYmIChB
UkNIX0FUOTFTQU05MjYwIHx8IEFSQ0hfQVQ5MVNBTTkyNjEpCisJdHJpc3RhdGUgIkFUOTFTQU05
WCAvIEFUOTFDQVA5IHdhdGNoZG9nIgorCWRlcGVuZHMgb24gQVJDSF9BVDkxICYmICFBUkNIX0FU
OTFSTTkyMDAKIAloZWxwCi0JICBXYXRjaGRvZyB0aW1lciBlbWJlZGRlZCBpbnRvIEFUOTFTQU05
WCBjaGlwcy4gVGhpcyB3aWxsIHJlYm9vdCB5b3VyCi0JICBzeXN0ZW0gd2hlbiB0aGUgdGltZW91
dCBpcyByZWFjaGVkLgorCSAgV2F0Y2hkb2cgdGltZXIgZW1iZWRkZWQgaW50byBBVDkxU0FNOVgg
YW5kIEFUOTFDQVA5IGNoaXBzLiBUaGlzIHdpbGwKKwkgIHJlYm9vdCB5b3VyIHN5c3RlbSB3aGVu
IHRoZSB0aW1lb3V0IGlzIHJlYWNoZWQuCiAKIGNvbmZpZyAyMTI4NV9XQVRDSERPRwogCXRyaXN0
YXRlICJEQzIxMjg1IHdhdGNoZG9nIgo=
------=_Part_32765_7117469.1225917395505--

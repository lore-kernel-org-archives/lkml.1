Return-Path: <linux-kernel-owner+w=401wt.eu-S1757446AbYBWXGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757446AbYBWXGY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755630AbYBWXGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:06:13 -0500
Received: from ns.store20.com ([212.7.7.16]:39808 "EHLO store20.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594AbYBWXGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:06:12 -0500
Subject: [PATCH] x86: fix build on non-C locales.
From: Priit Laes <plaes@plaes.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Content-Type: multipart/mixed; boundary="=-f6WBJzHpE9xGNGwbEbVh"
Date: Sun, 24 Feb 2008 01:05:50 +0200
Message-Id: <1203807950.12128.4.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.91 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f6WBJzHpE9xGNGwbEbVh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



--=-f6WBJzHpE9xGNGwbEbVh
Content-Description: 
Content-Disposition: inline; filename=x86-fix-build-on-non-C-locales.patch
Content-Transfer-Encoding: base64
Content-Type: text/x-patch; charset=UTF-8

eDg2OiBmaXggYnVpbGQgb24gc29tZSBub24tQyBsb2NhbGVzWzFdLg0KDQpGb3Igc29tZSBsb2Nh
bGVzIHJlZ2V4IHJhbmdlIFthLXpBLVpdIGRvZXMgbm90IHdvcmsgYXMgaXQgaXMgc3VwcG9zZWQg
dG8gDQpzbyB3ZSBoYXZlIHRvIHNwZWNpZnkgTEFORz1DIHRvIG1ha2UgaXQgd29yayBhcyBpbnRl
bmRlZC4NCg0KWzFdIGh0dHA6Ly9lbi53aWtpcGVkaWEub3JnL3dpa2kvRXN0b25pYW5fYWxwaGFi
ZXQNCg0KU2lnbmVkLW9mZi1ieTogUHJpaXQgTGFlcyA8cGxhZXNAcGxhZXMub3JnPg0KDQpkaWZm
IC0tZ2l0IGEvYXJjaC94ODYvdmRzby9NYWtlZmlsZSBiL2FyY2gveDg2L3Zkc28vTWFrZWZpbGUN
CmluZGV4IGYzODVhNGIuLmM1OGU3YjkgMTAwNjQ0DQotLS0gYS9hcmNoL3g4Ni92ZHNvL01ha2Vm
aWxlDQorKysgYi9hcmNoL3g4Ni92ZHNvL01ha2VmaWxlDQpAQCAtNTAsNyArNTAsOCBAQCBvYmot
JChWRFNPNjQteSkJCQkrPSB2ZHNvLXN5bXMubGRzDQogc2VkLXZkc29zeW0gOj0gLWUgJ3MvXjAw
Ki8wLycgXA0KIAktZSAncy9eXChbMC05YS1mQS1GXSpcKSAuIFwoVkRTT1thLXpBLVowLTlfXSpc
KSQkL1wyID0gMHhcMTsvcCcNCiBxdWlldF9jbWRfdmRzb3N5bSA9IFZEU09TWU0gJEANCi0gICAg
ICBjbWRfdmRzb3N5bSA9ICQoTk0pICQ8IHwgc2VkIC1uICQoc2VkLXZkc29zeW0pIHwgTENfQUxM
PUMgc29ydCA+ICRADQorICAgICAgY21kX3Zkc29zeW0gPSAkKE5NKSAkPCB8IExDX0FMTD1DIHNl
ZCAtbiAkKHNlZC12ZHNvc3ltKSBcDQorCSAgCQl8IExDX0FMTD1DIHNvcnQgPiAkQA0KIA0KICQo
b2JqKS8lLXN5bXMubGRzOiAkKG9iaikvJS5zby5kYmcgRk9SQ0UNCiAJJChjYWxsIGlmX2NoYW5n
ZWQsdmRzb3N5bSkNCg==


--=-f6WBJzHpE9xGNGwbEbVh--

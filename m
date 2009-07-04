Return-Path: <linux-kernel-owner+w=401wt.eu-S1759456AbZGDBqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456AbZGDBqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 21:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758774AbZGDBot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 21:44:49 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1777 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759123AbZGDBos convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 21:44:48 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Leo (Hao) Chen" <leochen@broadcom.com>
To: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Jean-Christophe PLAGNIOL-VILLARD" <plagnioj@jcrosoft.com>,
       "Scott Branden" <sbranden@broadcom.com>,
       "Leo (Hao) Chen" <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 18:44:38 -0700
Subject: [PATCH v2 13/18] new ARM SoC support: BCMRing
Thread-Topic: [PATCH v2 13/18] new ARM SoC support: BCMRing
Thread-Index: Acn8SP2+FKSPMaHjQJGKysCLihegSA==
Message-ID: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25BA6C1B@SJEXCHCCR02.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 66506B8D4CG20368457-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 0bd39d8149f37841be0b24c018f2f9d05129ee71 Mon Sep 17 00:00:00 2001
From: Leo Chen <leochen@broadcom.com>
Date: Fri, 3 Jul 2009 17:11:01 -0700
Subject: [PATCH 13/18] mach-bcmring/csp Makefile

add mach-bcmring/csp Makefile

Signed-off-by: Leo Chen <leochen@broadcom.com>
---
 arch/arm/mach-bcmring/csp/Makefile |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm/mach-bcmring/csp/Makefile

diff --git a/arch/arm/mach-bcmring/csp/Makefile b/arch/arm/mach-bcmring/csp/Makefile
new file mode 100644
index 0000000..648c037
--- /dev/null
+++ b/arch/arm/mach-bcmring/csp/Makefile
@@ -0,0 +1,3 @@
+obj-y += dmac/
+obj-y += tmr/
+obj-y += chipc/
--
1.6.0.6



Leo Hao Chen
Software Engineer
Broadcom Canada Inc.



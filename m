Return-Path: <linux-kernel-owner+w=401wt.eu-S1751165AbXCJVML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751165AbXCJVML (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:12:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751200AbXCJVMK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:12:10 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49268 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751165AbXCJVMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:12:09 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:09:11 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: Andrew Morton <akpm@osdl.org>, ben-linux@fluff.org
Subject: [PATCH] ARM:  Remove unused header file.
Message-ID: <Pine.LNX.4.64.0703101603360.26603@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


  Delete the apparently unused header file
arch/arm/mach-s3c2410/bast.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/arm/mach-s3c2410/bast.h b/arch/arm/mach-s3c2410/bast.h
deleted file mode 100644
index e985437..0000000
--- a/arch/arm/mach-s3c2410/bast.h
+++ /dev/null
@@ -1,2 +0,0 @@
-/* linux/arch/arm/mach-s3c2410/bast.h
-extern void bast_init_irq(void);
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

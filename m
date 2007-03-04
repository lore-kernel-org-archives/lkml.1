Return-Path: <linux-kernel-owner+w=401wt.eu-S1751707AbXCDNgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbXCDNgK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 08:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbXCDNgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 08:36:10 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:47812 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbXCDNgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 08:36:09 -0500
X-Originating-Ip: 74.109.98.130
Date: Sun, 4 Mar 2007 08:17:33 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: trivial@kernel.org
Subject: [PATCH] Kconfig:  A couple of grammatical fixes in arch/i386/Kconfig.
Message-ID: <Pine.LNX.4.64.0703040814430.27756@CPE00045a9c397f-CM001225dbafb6>
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


  Fix a couple grammatical errors in arch/i386/Kconfig.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 2f76725..b7a3b2f 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -850,9 +850,9 @@ config RELOCATABLE
 	bool "Build a relocatable kernel(EXPERIMENTAL)"
 	depends on EXPERIMENTAL
 	help
-	  This build a kernel image that retains relocation information
+	  This builds a kernel image that retains relocation information
           so it can be loaded someplace besides the default 1MB.
-	  The relocations tend to the kernel binary about 10% larger,
+	  The relocations tend to make the kernel binary about 10% larger,
           but are discarded at runtime.

 	  One use is for the kexec on panic case where the recovery kernel
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

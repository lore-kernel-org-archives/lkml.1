Return-Path: <linux-kernel-owner+w=401wt.eu-S1750738AbXCJVUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750738AbXCJVUr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 16:20:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbXCJVUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 16:20:47 -0500
Received: from nic.NetDirect.CA ([216.16.235.2]:49462 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbXCJVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 16:20:46 -0500
X-Originating-Ip: 74.109.98.130
Date: Sat, 10 Mar 2007 16:17:28 -0500 (EST)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@CPE00045a9c397f-CM001225dbafb6
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: galak@kernel.crashing.org, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] PPC: Delete unused header file.
Message-ID: <Pine.LNX.4.64.0703101616060.27495@CPE00045a9c397f-CM001225dbafb6>
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


  Delete apparently unused header file
arch/powerpc/platforms/83xx/mpc834x_itx.h.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/arch/powerpc/platforms/83xx/mpc834x_itx.h b/arch/powerpc/platforms/83xx/mpc834x_itx.h
deleted file mode 100644
index 174ca4e..0000000
--- a/arch/powerpc/platforms/83xx/mpc834x_itx.h
+++ /dev/null
@@ -1,23 +0,0 @@
-/*
- * arch/powerpc/platforms/83xx/mpc834x_itx.h
- *
- * MPC834X ITX common board definitions
- *
- * Maintainer: Kumar Gala <galak@kernel.crashing.org>
- *
- * This program is free software; you can redistribute  it and/or modify it
- * under  the terms of  the GNU General  Public License as published by the
- * Free Software Foundation;  either version 2 of the  License, or (at your
- * option) any later version.
- *
- */
-
-#ifndef __MACH_MPC83XX_ITX_H__
-#define __MACH_MPC83XX_ITX_H__
-
-#define PIRQA	MPC83xx_IRQ_EXT4
-#define PIRQB	MPC83xx_IRQ_EXT5
-#define PIRQC	MPC83xx_IRQ_EXT6
-#define PIRQD	MPC83xx_IRQ_EXT7
-
-#endif				/* __MACH_MPC83XX_ITX_H__ */

-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================

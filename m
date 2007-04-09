Return-Path: <linux-kernel-owner+w=401wt.eu-S966024AbXDIVci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966024AbXDIVci (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030300AbXDIVb7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:31:59 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:33445 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030295AbXDIVby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:31:54 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 11/18] ARM: OMAP: Tabify mux.c
Date: Mon,  9 Apr 2007 17:30:54 -0400
Message-Id: <1176154302614-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761542981742-git-send-email-tony@atomide.com>
References: <1176154261668-git-send-email-tony@atomide.com> <11761542642563-git-send-email-tony@atomide.com> <11761542683139-git-send-email-tony@atomide.com> <11761542712251-git-send-email-tony@atomide.com> <11761542731458-git-send-email-tony@atomide.com> <1176154277435-git-send-email-tony@atomide.com> <11761542841909-git-send-email-tony@atomide.com> <1176154286590-git-send-email-tony@atomide.com> <11761542912185-git-send-email-tony@atomide.com> <1176154294883-git-send-email-tony@atomide.com> <11761542981742-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tabify mux.c, no functional changes.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/mux.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -53,8 +53,8 @@ MUX_CFG_24XX("W19_24XX_SYS_NIRQ",	0x12c,	0,	1,	1,	1)
 MUX_CFG_24XX("W14_24XX_SYS_CLKOUT",	0x137,	0,	1,	1,	1)
 
 /* 24xx GPMC chipselects, wait pin monitoring */
-MUX_CFG_24XX("E2_GPMC_NCS2",	0x08e,	0,	1,	1,	1)
-MUX_CFG_24XX("L2_GPMC_NCS7",	0x093,	0,	1,	1,	1)
+MUX_CFG_24XX("E2_GPMC_NCS2",		0x08e,	0,	1,	1,	1)
+MUX_CFG_24XX("L2_GPMC_NCS7",		0x093,	0,	1,	1,	1)
 MUX_CFG_24XX("L3_GPMC_WAIT0",		0x09a,	0,	1,	1,	1)
 MUX_CFG_24XX("N7_GPMC_WAIT1",		0x09b,	0,	1,	1,	1)
 MUX_CFG_24XX("M1_GPMC_WAIT2",		0x09c,	0,	1,	1,	1)
@@ -67,18 +67,18 @@ MUX_CFG_24XX("W15_24XX_MCBSP2_DR",	0x126,	1,	1,	0,	1)
 MUX_CFG_24XX("V15_24XX_MCBSP2_DX",	0x127,	1,	1,	0,	1)
 
 /* 24xx GPIO */
-MUX_CFG_24XX("M21_242X_GPIO11",		0x0c9,  3,      1,      1,      1)
-MUX_CFG_24XX("P21_242X_GPIO12",	0x0ca,	3,	0,	0,	1)
-MUX_CFG_24XX("AA10_242X_GPIO13",	0x0e5,  3,      0,      0,      1)
-MUX_CFG_24XX("AA6_242X_GPIO14",		0x0e6,  3,      0,      0,      1)
-MUX_CFG_24XX("AA4_242X_GPIO15",		0x0e7,  3,      0,      0,      1)
-MUX_CFG_24XX("Y11_242X_GPIO16",		0x0e8,  3,      0,      0,      1)
-MUX_CFG_24XX("AA12_242X_GPIO17",	0x0e9,  3,      0,      0,      1)
-MUX_CFG_24XX("AA8_242X_GPIO58",		0x0ea,  3,      0,      0,      1)
+MUX_CFG_24XX("M21_242X_GPIO11",		0x0c9,	3,	1,	1,	1)
+MUX_CFG_24XX("P21_242X_GPIO12",		0x0ca,	3,	0,	0,	1)
+MUX_CFG_24XX("AA10_242X_GPIO13",	0x0e5,	3,	0,	0,	1)
+MUX_CFG_24XX("AA6_242X_GPIO14",		0x0e6,	3,	0,	0,	1)
+MUX_CFG_24XX("AA4_242X_GPIO15",		0x0e7,	3,	0,	0,	1)
+MUX_CFG_24XX("Y11_242X_GPIO16",		0x0e8,	3,	0,	0,	1)
+MUX_CFG_24XX("AA12_242X_GPIO17",	0x0e9,	3,	0,	0,	1)
+MUX_CFG_24XX("AA8_242X_GPIO58",		0x0ea,	3,	0,	0,	1)
 MUX_CFG_24XX("Y20_24XX_GPIO60",		0x12c,	3,	0,	0,	1)
-MUX_CFG_24XX("W4__24XX_GPIO74",		0x0f2,  3,      0,      0,      1)
+MUX_CFG_24XX("W4__24XX_GPIO74",		0x0f2,	3,	0,	0,	1)
 MUX_CFG_24XX("M15_24XX_GPIO92",		0x10a,	3,	0,	0,	1)
-MUX_CFG_24XX("J15_24XX_GPIO99",	0x113,	3,	1,	1,	1)
+MUX_CFG_24XX("J15_24XX_GPIO99",		0x113,	3,	1,	1,	1)
 MUX_CFG_24XX("V14_24XX_GPIO117",	0x128,	3,	1,	0,	1)
 MUX_CFG_24XX("P14_24XX_GPIO125",	0x140,	3,	1,	1,	1)
 
@@ -95,17 +95,17 @@ MUX_CFG_24XX("T3_242X_GPIO55",		0xd9,	3,	0,	0,	1)
 MUX_CFG_24XX("U2_242X_GPIO56",		0xda,	3,	0,	0,	1)
 
 /* 24xx external DMA requests */
-MUX_CFG_24XX("AA10_242X_DMAREQ0",	0x0e5,  2,      0,      0,      1)
-MUX_CFG_24XX("AA6_242X_DMAREQ1",	0x0e6,  2,      0,      0,      1)
-MUX_CFG_24XX("E4_242X_DMAREQ2",		0x074,  2,      0,      0,      1)
-MUX_CFG_24XX("G4_242X_DMAREQ3",		0x073,  2,      0,      0,      1)
-MUX_CFG_24XX("D3_242X_DMAREQ4",		0x072,  2,      0,      0,      1)
-MUX_CFG_24XX("E3_242X_DMAREQ5",		0x071,  2,      0,      0,      1)
+MUX_CFG_24XX("AA10_242X_DMAREQ0",	0x0e5,	2,	0,	0,	1)
+MUX_CFG_24XX("AA6_242X_DMAREQ1",	0x0e6,	2,	0,	0,	1)
+MUX_CFG_24XX("E4_242X_DMAREQ2",		0x074,	2,	0,	0,	1)
+MUX_CFG_24XX("G4_242X_DMAREQ3",		0x073,	2,	0,	0,	1)
+MUX_CFG_24XX("D3_242X_DMAREQ4",		0x072,	2,	0,	0,	1)
+MUX_CFG_24XX("E3_242X_DMAREQ5",		0x071,	2,	0,	0,	1)
 
 /* TSC IRQ */
 MUX_CFG_24XX("P20_24XX_TSC_IRQ",	0x108,	0,	0,	0,	1)
 
-/* UART3  */
+/* UART3 */
 MUX_CFG_24XX("K15_24XX_UART3_TX",	0x118,	0,	0,	0,	1)
 MUX_CFG_24XX("K14_24XX_UART3_RX",	0x119,	0,	0,	0,	1)
 
-- 
1.4.4.2


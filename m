Return-Path: <linux-kernel-owner+w=401wt.eu-S932231AbXDDSKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932231AbXDDSKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934060AbXDDSKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:10:49 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:37735 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932456AbXDDSJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:09:59 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Tony Lindgren <tony@atomide.com>
Subject: [PATCH 42/90] ARM: OMAP: Tabify mux.c
Date: Wed,  4 Apr 2007 14:05:21 -0400
Message-Id: <11757100821353-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757100811771-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tabify mux.c

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/mux.c |   38 +++++++++++++++++++-------------------
 1 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 0439906..0575097 100644
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


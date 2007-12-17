Return-Path: <linux-kernel-owner+w=401wt.eu-S1761627AbXLQTcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761627AbXLQTcT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:32:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757818AbXLQTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:24 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2932 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442AbXLQTbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:22 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Dirk Opfer <dirk@opfer-online.de>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: [PATCH] include/asm-arm/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:02 -0800
Message-Id: <1197919875-5288-3-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-arm/arch-ixp4xx/ixp4xx-regs.h |   34 +++++++++++++-------------
 include/asm-arm/arch-pxa/pxa-regs.h       |   36 ++++++++++++++--------------
 include/asm-arm/hardware/it8152.h         |    2 +-
 include/asm-arm/mach/udc_pxa2xx.h         |    2 +-
 4 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/include/asm-arm/arch-ixp4xx/ixp4xx-regs.h b/include/asm-arm/arch-ixp4xx/ixp4xx-regs.h
index 5d949d7..1205c28 100644
--- a/include/asm-arm/arch-ixp4xx/ixp4xx-regs.h
+++ b/include/asm-arm/arch-ixp4xx/ixp4xx-regs.h
@@ -587,23 +587,23 @@
 #define UICR1_IM14	(1 << 6)	/* Interrupt mask ep 14 */
 #define UICR1_IM15	(1 << 7)	/* Interrupt mask ep 15 */
 
-#define USIR0_IR0	(1 << 0)	/* Interrup request ep 0 */
-#define USIR0_IR1	(1 << 1)	/* Interrup request ep 1 */
-#define USIR0_IR2	(1 << 2)	/* Interrup request ep 2 */
-#define USIR0_IR3	(1 << 3)	/* Interrup request ep 3 */
-#define USIR0_IR4	(1 << 4)	/* Interrup request ep 4 */
-#define USIR0_IR5	(1 << 5)	/* Interrup request ep 5 */
-#define USIR0_IR6	(1 << 6)	/* Interrup request ep 6 */
-#define USIR0_IR7	(1 << 7)	/* Interrup request ep 7 */
-
-#define USIR1_IR8	(1 << 0)	/* Interrup request ep 8 */
-#define USIR1_IR9	(1 << 1)	/* Interrup request ep 9 */
-#define USIR1_IR10	(1 << 2)	/* Interrup request ep 10 */
-#define USIR1_IR11	(1 << 3)	/* Interrup request ep 11 */
-#define USIR1_IR12	(1 << 4)	/* Interrup request ep 12 */
-#define USIR1_IR13	(1 << 5)	/* Interrup request ep 13 */
-#define USIR1_IR14	(1 << 6)	/* Interrup request ep 14 */
-#define USIR1_IR15	(1 << 7)	/* Interrup request ep 15 */
+#define USIR0_IR0	(1 << 0)	/* Interrupt request ep 0 */
+#define USIR0_IR1	(1 << 1)	/* Interrupt request ep 1 */
+#define USIR0_IR2	(1 << 2)	/* Interrupt request ep 2 */
+#define USIR0_IR3	(1 << 3)	/* Interrupt request ep 3 */
+#define USIR0_IR4	(1 << 4)	/* Interrupt request ep 4 */
+#define USIR0_IR5	(1 << 5)	/* Interrupt request ep 5 */
+#define USIR0_IR6	(1 << 6)	/* Interrupt request ep 6 */
+#define USIR0_IR7	(1 << 7)	/* Interrupt request ep 7 */
+
+#define USIR1_IR8	(1 << 0)	/* Interrupt request ep 8 */
+#define USIR1_IR9	(1 << 1)	/* Interrupt request ep 9 */
+#define USIR1_IR10	(1 << 2)	/* Interrupt request ep 10 */
+#define USIR1_IR11	(1 << 3)	/* Interrupt request ep 11 */
+#define USIR1_IR12	(1 << 4)	/* Interrupt request ep 12 */
+#define USIR1_IR13	(1 << 5)	/* Interrupt request ep 13 */
+#define USIR1_IR14	(1 << 6)	/* Interrupt request ep 14 */
+#define USIR1_IR15	(1 << 7)	/* Interrupt request ep 15 */
 
 #define DCMD_LENGTH	0x01fff		/* length mask (max = 8K - 1) */
 
diff --git a/include/asm-arm/arch-pxa/pxa-regs.h b/include/asm-arm/arch-pxa/pxa-regs.h
index 6b33df6..7a110a0 100644
--- a/include/asm-arm/arch-pxa/pxa-regs.h
+++ b/include/asm-arm/arch-pxa/pxa-regs.h
@@ -737,25 +737,25 @@
 
 #define USIR0		__REG(0x40600058)  /* UDC Status Interrupt Register 0 */
 
-#define USIR0_IR0	(1 << 0)	/* Interrup request ep 0 */
-#define USIR0_IR1	(1 << 1)	/* Interrup request ep 1 */
-#define USIR0_IR2	(1 << 2)	/* Interrup request ep 2 */
-#define USIR0_IR3	(1 << 3)	/* Interrup request ep 3 */
-#define USIR0_IR4	(1 << 4)	/* Interrup request ep 4 */
-#define USIR0_IR5	(1 << 5)	/* Interrup request ep 5 */
-#define USIR0_IR6	(1 << 6)	/* Interrup request ep 6 */
-#define USIR0_IR7	(1 << 7)	/* Interrup request ep 7 */
+#define USIR0_IR0	(1 << 0)	/* Interrupt request ep 0 */
+#define USIR0_IR1	(1 << 1)	/* Interrupt request ep 1 */
+#define USIR0_IR2	(1 << 2)	/* Interrupt request ep 2 */
+#define USIR0_IR3	(1 << 3)	/* Interrupt request ep 3 */
+#define USIR0_IR4	(1 << 4)	/* Interrupt request ep 4 */
+#define USIR0_IR5	(1 << 5)	/* Interrupt request ep 5 */
+#define USIR0_IR6	(1 << 6)	/* Interrupt request ep 6 */
+#define USIR0_IR7	(1 << 7)	/* Interrupt request ep 7 */
 
 #define USIR1		__REG(0x4060005C)  /* UDC Status Interrupt Register 1 */
 
-#define USIR1_IR8	(1 << 0)	/* Interrup request ep 8 */
-#define USIR1_IR9	(1 << 1)	/* Interrup request ep 9 */
-#define USIR1_IR10	(1 << 2)	/* Interrup request ep 10 */
-#define USIR1_IR11	(1 << 3)	/* Interrup request ep 11 */
-#define USIR1_IR12	(1 << 4)	/* Interrup request ep 12 */
-#define USIR1_IR13	(1 << 5)	/* Interrup request ep 13 */
-#define USIR1_IR14	(1 << 6)	/* Interrup request ep 14 */
-#define USIR1_IR15	(1 << 7)	/* Interrup request ep 15 */
+#define USIR1_IR8	(1 << 0)	/* Interrupt request ep 8 */
+#define USIR1_IR9	(1 << 1)	/* Interrupt request ep 9 */
+#define USIR1_IR10	(1 << 2)	/* Interrupt request ep 10 */
+#define USIR1_IR11	(1 << 3)	/* Interrupt request ep 11 */
+#define USIR1_IR12	(1 << 4)	/* Interrupt request ep 12 */
+#define USIR1_IR13	(1 << 5)	/* Interrupt request ep 13 */
+#define USIR1_IR14	(1 << 6)	/* Interrupt request ep 14 */
+#define USIR1_IR15	(1 << 7)	/* Interrupt request ep 15 */
 
 #elif defined(CONFIG_PXA27x)
 
@@ -1020,7 +1020,7 @@
 #define ICSR0		__REG(0x40800014)  /* ICP Status Register 0 */
 #define ICSR1		__REG(0x40800018)  /* ICP Status Register 1 */
 
-#define ICCR0_AME	(1 << 7)	/* Adress match enable */
+#define ICCR0_AME	(1 << 7)	/* Address match enable */
 #define ICCR0_TIE	(1 << 6)	/* Transmit FIFO interrupt enable */
 #define ICCR0_RIE	(1 << 5)	/* Recieve FIFO interrupt enable */
 #define ICCR0_RXE	(1 << 4)	/* Receive enable */
@@ -1668,7 +1668,7 @@
 #define SSCR1_TSRE		(1 << 21)	/* Transmit Service Request Enable */
 #define SSCR1_RSRE		(1 << 20)	/* Receive Service Request Enable */
 #define SSCR1_TINTE		(1 << 19)	/* Receiver Time-out Interrupt enable */
-#define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interupt Enable */
+#define SSCR1_PINTE		(1 << 18)	/* Peripheral Trailing Byte Interrupt Enable */
 #define SSCR1_STRF		(1 << 15)	/* Select FIFO or EFWR */
 #define SSCR1_EFWR		(1 << 14)	/* Enable FIFO Write/Read */
 
diff --git a/include/asm-arm/hardware/it8152.h b/include/asm-arm/hardware/it8152.h
index aaebb61..74b5fff 100644
--- a/include/asm-arm/hardware/it8152.h
+++ b/include/asm-arm/hardware/it8152.h
@@ -42,7 +42,7 @@ extern unsigned long it8152_base_address;
 #define IT8152_GPIO_GPDR		__REG_IT8152(0x3f00500)
 
 /*
-  Interrup contoler per register summary:
+  Interrupt controller per register summary:
   ---------------------------------------
   LCDNIRR:
   IT8152_LD_IRQ(8) PCICLK stop
diff --git a/include/asm-arm/mach/udc_pxa2xx.h b/include/asm-arm/mach/udc_pxa2xx.h
index ff0a957..dd4b369 100644
--- a/include/asm-arm/mach/udc_pxa2xx.h
+++ b/include/asm-arm/mach/udc_pxa2xx.h
@@ -16,7 +16,7 @@ struct pxa2xx_udc_mach_info {
 #define	PXA2XX_UDC_CMD_DISCONNECT	1	/* so host won't see us */
 
 	/* Boards following the design guidelines in the developer's manual,
-	 * with on-chip GPIOs not Lubbock's wierd hardware, can have a sane
+	 * with on-chip GPIOs not Lubbock's weird hardware, can have a sane
 	 * VBUS IRQ and omit the methods above.  Store the GPIO number
 	 * here; for GPIO 0, also mask in one of the pxa_gpio_mode() bits.
 	 */
-- 
1.5.3.7.949.g2221a6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1422707AbXDDSWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422707AbXDDSWl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 14:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422722AbXDDSWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 14:22:24 -0400
Received: from nlpi001.sbcis.sbc.com ([207.115.36.30]:39367 "EHLO
	nlpi001.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934089AbXDDSNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 14:13:05 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Trilok Soni <soni.trilok@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 67/90] ARM: OMAP: Replace mach-omap/omap2 with mach-omap2
Date: Wed,  4 Apr 2007 14:05:46 -0400
Message-Id: <11757101513037-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11757101481276-git-send-email-tony@atomide.com>
References: 11757088953851-git-send-email-tony@atomide.com <11757099691323-git-send-email-tony@atomide.com> <11757099743984-git-send-email-tony@atomide.com> <1175709977545-git-send-email-tony@atomide.com> <1175709988265-git-send-email-tony@atomide.com> <11757099942493-git-send-email-tony@atomide.com> <11757100011056-git-send-email-tony@atomide.com> <1175710003925-git-send-email-tony@atomide.com> <11757100063945-git-send-email-tony@atomide.com> <11757100092910-git-send-email-tony@atomide.com> <11757100112473-git-send-email-tony@atomide.com> <11757100143517-git-send-email-tony@atomide.com> <11757100163760-git-send-email-tony@atomide.com> <11757100181189-git-send-email-tony@atomide.com> <11757100214151-git-send-email-tony@atomide.com> <11757100242980-git-send-email-tony@atomide.com> <1175710026446-git-send-email-tony@atomide.com> <11757100281957-git-send-email-tony@atomide.com> <11757100302964-git-send-email-tony@atomide.com> <1175710033286-git-send-email-tony@atomide.com> <117!
 57100403021-git-send-email-tony@atomide.com> <11757100423982-git-send-email-tony@atomide.com> <117571004562-git-send-email-tony@atomide.com> <11757100491583-git-send-email-tony@atomide.com> <11757100511172-git-send-email-tony@atomide.com> <1175710059333-git-send-email-tony@atomide.com> <11757100623383-git-send-email-tony@atomide.com> <11757100641006-git-send-email-tony@atomide.com> <11757100661228-git-send-email-tony@atomide.com> <11757100691131-git-send-email-tony@atomide.com> <11757100713004-git-send-email-tony@atomide.com> <11757100752021-git-send-email-tony@atomide.com> <11757100781275-git-send-email-tony@atomide.com> <11757100811771-git-send-email-tony@atomide.com> <11757100821353-git-send-email-tony@atomide.com> <11757100853841-git-send-email-tony@atomide.com> <1175710087578-git-send-email-tony@atomide.com> <11757100911247-git-send-email-tony@atomide.com> <1175710093864-git-send-email-tony@atomide.com> <11757100952384-git-send-email-tony@atomide.com> <11757100982726-g!
 it-send-email-tony@atomide.com> <11757101012787-git-send-email-tony@atomide.com> <1175710103340-git-send-email-tony@atomide.com> <11757101072553-git-send-email-tony@atomide.com> <11757101101180-git-send-email-tony@atomide.com> <11757101123620-git-send-email-tony@atomide.com> <11757101141643-git-send-email-tony@atomide.com> <
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trilok Soni <soni.trilok@gmail.com>

- Update file headers with correct file paths.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-apollon.c    |    2 +-
 arch/arm/mach-omap2/board-n800-audio.c |    2 +-
 arch/arm/mach-omap2/board-n800-flash.c |    2 +-
 arch/arm/mach-omap2/board-n800-usb.c   |    2 +-
 arch/arm/mach-omap2/board-n800.c       |    2 +-
 arch/arm/mach-omap2/usb-tusb6010.c     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mach-omap2/board-apollon.c b/arch/arm/mach-omap2/board-apollon.c
index 5e1cada..5488961 100644
--- a/arch/arm/mach-omap2/board-apollon.c
+++ b/arch/arm/mach-omap2/board-apollon.c
@@ -4,7 +4,7 @@
  * Copyright (C) 2005,2006 Samsung Electronics
  * Author: Kyungmin Park <kyungmin.park@samsung.com>
  *
- * Modified from mach-omap/omap2/board-h4.c
+ * Modified from mach-omap2/board-h4.c
  *
  * Code for apollon OMAP2 board. Should work on many OMAP2 systems where
  * the bootloader passes the board-specific data to the kernel.
diff --git a/arch/arm/mach-omap2/board-n800-audio.c b/arch/arm/mach-omap2/board-n800-audio.c
index 1608d3d..8e36691 100644
--- a/arch/arm/mach-omap2/board-n800-audio.c
+++ b/arch/arm/mach-omap2/board-n800-audio.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/board-n800-audio.c
+ * linux/arch/arm/mach-omap2/board-n800-audio.c
  *
  * Copyright (C) 2006 Nokia Corporation
  * Contact: Juha Yrj?l?
diff --git a/arch/arm/mach-omap2/board-n800-flash.c b/arch/arm/mach-omap2/board-n800-flash.c
index 3a4c52a..cd302ab 100644
--- a/arch/arm/mach-omap2/board-n800-flash.c
+++ b/arch/arm/mach-omap2/board-n800-flash.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/board-n800-flash.c
+ * linux/arch/arm/mach-omap2/board-n800-flash.c
  *
  * Copyright (C) 2006 Nokia Corporation
  * Author: Juha Yrjola
diff --git a/arch/arm/mach-omap2/board-n800-usb.c b/arch/arm/mach-omap2/board-n800-usb.c
index 75243ac..e43690d 100644
--- a/arch/arm/mach-omap2/board-n800-usb.c
+++ b/arch/arm/mach-omap2/board-n800-usb.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/board-n800-usb.c
+ * linux/arch/arm/mach-omap2/board-n800-usb.c
  *
  * Copyright (C) 2006 Nokia Corporation
  * Author: Juha Yrj?l?
diff --git a/arch/arm/mach-omap2/board-n800.c b/arch/arm/mach-omap2/board-n800.c
index 2188294..69e5d36 100644
--- a/arch/arm/mach-omap2/board-n800.c
+++ b/arch/arm/mach-omap2/board-n800.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/board-n800.c
+ * linux/arch/arm/mach-omap2/board-n800.c
  *
  * Copyright (C) 2005 Nokia Corporation
  * Author: Juha Yrj?l? <juha.yrjola@nokia.com>
diff --git a/arch/arm/mach-omap2/usb-tusb6010.c b/arch/arm/mach-omap2/usb-tusb6010.c
index 497f733..80bb42e 100644
--- a/arch/arm/mach-omap2/usb-tusb6010.c
+++ b/arch/arm/mach-omap2/usb-tusb6010.c
@@ -1,5 +1,5 @@
 /*
- * linux/arch/arm/mach-omap/omap2/usb-tusb6010.c
+ * linux/arch/arm/mach-omap2/usb-tusb6010.c
  *
  * Copyright (C) 2006 Nokia Corporation
  *
-- 
1.4.4.2


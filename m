Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXDIVen@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXDIVen (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 17:34:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbXDIVel
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 17:34:41 -0400
Received: from nlpi015.sbcis.sbc.com ([207.115.36.44]:35312 "EHLO
	nlpi015.sbcis.sbc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXDIVei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 17:34:38 -0400
X-ORBL: [67.117.73.34]
From: Tony Lindgren <tony@atomide.com>
To: linux-kernel@vger.kernel.org
Cc: Trilok Soni <soni.trilok@gmail.com>, Tony Lindgren <tony@atomide.com>
Subject: [PATCH 6/7] ARM: OMAP: Replace mach-omap/omap2 with mach-omap2
Date: Mon,  9 Apr 2007 17:34:01 -0400
Message-Id: <11761544642104-git-send-email-tony@atomide.com>
X-Mailer: git-send-email 1.4.4.2
In-Reply-To: <11761544583886-git-send-email-tony@atomide.com>
References: <11761544421667-git-send-email-tony@atomide.com> <11761544452798-git-send-email-tony@atomide.com> <11761544492069-git-send-email-tony@atomide.com> <11761544523253-git-send-email-tony@atomide.com> <11761544544019-git-send-email-tony@atomide.com> <11761544583886-git-send-email-tony@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Trilok Soni <soni.trilok@gmail.com>

Update board Apollon with correct file path.

Signed-off-by: Trilok Soni <soni.trilok@gmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 arch/arm/mach-omap2/board-apollon.c    |    2 +-
 arch/arm/mach-omap2/usb-tusb6010.c     |    2 +-
 6 files changed, 6 insertions(+), 6 deletions(-)

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


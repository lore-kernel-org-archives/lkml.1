Return-Path: <linux-kernel-owner+w=401wt.eu-S1761158AbXLQTch@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761158AbXLQTch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:32:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758096AbXLQTbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:24 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2934 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757763AbXLQTbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Blackfin Architecture Team 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: [PATCH] arch/blackfin/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:03 -0800
Message-Id: <1197919875-5288-4-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/blackfin/kernel/early_printk.c      |    2 +-
 arch/blackfin/mach-bf548/ints-priority.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/blackfin/kernel/early_printk.c b/arch/blackfin/kernel/early_printk.c
index 724f4a5..fb11ce6 100644
--- a/arch/blackfin/kernel/early_printk.c
+++ b/arch/blackfin/kernel/early_printk.c
@@ -187,7 +187,7 @@ asmlinkage void __init init_early_exception_vectors(void)
 	bfin_write_EVT15(early_trap);
 	CSYNC();
 
-	/* Set all the return from interupt, exception, NMI to a known place
+	/* Set all the return from interrupt, exception, NMI to a known place
 	 * so if we do a RETI, RETX or RETN by mistake - we go somewhere known
 	 * Note - don't change RETS - we are in a subroutine, or
 	 * RETE - since it might screw up if emulator is attached
diff --git a/arch/blackfin/mach-bf548/ints-priority.c b/arch/blackfin/mach-bf548/ints-priority.c
index cb0ebac..546517c 100644
--- a/arch/blackfin/mach-bf548/ints-priority.c
+++ b/arch/blackfin/mach-bf548/ints-priority.c
@@ -4,7 +4,7 @@
  * Author:       Michael Hennerich
  *
  * Created:
- * Description:  Set up the interupt priorities
+ * Description:  Set up the interrupt priorities
  *
  * Modified:
  *               Copyright 2004-2006 Analog Devices Inc.
-- 
1.5.3.7.949.g2221a6


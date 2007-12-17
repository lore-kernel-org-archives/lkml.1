Return-Path: <linux-kernel-owner+w=401wt.eu-S933124AbXLQTgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933124AbXLQTgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:36:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbXLQTbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:38 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2958 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760526AbXLQTbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:33 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Marcelo Tosatti <marcelo@kvack.org>, Paul Mackerras <paulus@samba.org>,
       Vitaly Bordug <vitb@kernel.crashing.org>, linuxppc-dev@ozlabs.org
Subject: [PATCH] arch/ppc/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:14 -0800
Message-Id: <1197919875-5288-15-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918890.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/ppc/syslib/ppc8xx_pic.c |    2 +-
 arch/ppc/syslib/ppc_sys.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/ppc/syslib/ppc8xx_pic.c b/arch/ppc/syslib/ppc8xx_pic.c
index e8619c7..bce9a75 100644
--- a/arch/ppc/syslib/ppc8xx_pic.c
+++ b/arch/ppc/syslib/ppc8xx_pic.c
@@ -16,7 +16,7 @@ extern int cpm_get_irq(void);
  * the only interrupt controller.  Some boards, like the MBX and
  * Sandpoint have the 8259 as a secondary controller.  Depending
  * upon the processor type, the internal controller can have as
- * few as 16 interrups or as many as 64.  We could use  the
+ * few as 16 interrupts or as many as 64.  We could use  the
  * "clear_bit()" and "set_bit()" functions like other platforms,
  * but they are overkill for us.
  */
diff --git a/arch/ppc/syslib/ppc_sys.c b/arch/ppc/syslib/ppc_sys.c
index 2d48018..837183c 100644
--- a/arch/ppc/syslib/ppc_sys.c
+++ b/arch/ppc/syslib/ppc_sys.c
@@ -185,7 +185,7 @@ void platform_notify_map(const struct platform_notify_dev_map *map,
  */
 
 /*
-   Here we'll replace .name pointers with fixed-lenght strings
+   Here we'll replace .name pointers with fixed-length strings
    Hereby, this should be called *before* any func stuff triggeded.
  */
 void ppc_sys_device_initfunc(void)
-- 
1.5.3.7.949.g2221a6


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761500AbXLQTdd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761500AbXLQTdd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:33:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759631AbXLQTb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:28 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2940 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758015AbXLQTbZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Tony Luck <tony.luck@intel.com>,
       linux-ia64@vger.kernel.org
Subject: [PATCH] include/asm-ia64/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:06 -0800
Message-Id: <1197919875-5288-7-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-ia64/hw_irq.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-ia64/hw_irq.h b/include/asm-ia64/hw_irq.h
index bba5baa..7e6e377 100644
--- a/include/asm-ia64/hw_irq.h
+++ b/include/asm-ia64/hw_irq.h
@@ -63,7 +63,7 @@ extern int ia64_last_device_vector;
 #define IA64_NUM_DEVICE_VECTORS		(IA64_LAST_DEVICE_VECTOR - IA64_FIRST_DEVICE_VECTOR + 1)
 
 #define IA64_MCA_RENDEZ_VECTOR		0xe8	/* MCA rendez interrupt */
-#define IA64_PERFMON_VECTOR		0xee	/* performanc monitor interrupt vector */
+#define IA64_PERFMON_VECTOR		0xee	/* performance monitor interrupt vector */
 #define IA64_TIMER_VECTOR		0xef	/* use highest-prio group 15 interrupt for timer */
 #define	IA64_MCA_WAKEUP_VECTOR		0xf0	/* MCA wakeup (must be >MCA_RENDEZ_VECTOR) */
 #define IA64_IPI_LOCAL_TLB_FLUSH	0xfc	/* SMP flush local TLB */
-- 
1.5.3.7.949.g2221a6


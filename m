Return-Path: <linux-kernel-owner+w=401wt.eu-S1762386AbXLQTcw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762386AbXLQTcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:32:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758248AbXLQTbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:31:25 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2935 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757823AbXLQTbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:31:23 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] arch/h8300/: Spelling fixes
Date: Mon, 17 Dec 2007 11:30:04 -0800
Message-Id: <1197919875-5288-5-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918889.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/h8300/platform/h8s/ints.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/h8300/platform/h8s/ints.c b/arch/h8300/platform/h8s/ints.c
index 551fd5f..ac10b97 100644
--- a/arch/h8300/platform/h8s/ints.c
+++ b/arch/h8300/platform/h8s/ints.c
@@ -121,7 +121,7 @@ void __init init_IRQ(void)
 		printk("virtual vector at 0x%08lx\n",(unsigned long)ramvec);
 
 #if defined(CONFIG_GDB_DEBUG)
-	/* save orignal break vector */
+	/* save original break vector */
 	break_vec = ramvec[TRAP3_VEC];
 #else
 	break_vec = VECTOR(trace_break);
-- 
1.5.3.7.949.g2221a6


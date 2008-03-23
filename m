Return-Path: <linux-kernel-owner+w=401wt.eu-S1764355AbYCWItA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764355AbYCWItA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 04:49:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760055AbYCWILX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:11:23 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2328 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760049AbYCWILU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:11:20 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 053/148] include/asm-x86/irq_32.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:02:28 -0700
Message-Id: <1206259443-13210-54-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/irq_32.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/irq_32.h b/include/asm-x86/irq_32.h
index aca9c96..0b79f31 100644
--- a/include/asm-x86/irq_32.h
+++ b/include/asm-x86/irq_32.h
@@ -15,7 +15,7 @@
 #include "irq_vectors.h"
 #include <asm/thread_info.h>
 
-static __inline__ int irq_canonicalize(int irq)
+static inline int irq_canonicalize(int irq)
 {
 	return ((irq == 2) ? 9 : irq);
 }
-- 
1.5.4.rc2


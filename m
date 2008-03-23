Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbYCWJFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbYCWJFb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 05:05:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760298AbYCWIMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 04:12:22 -0400
Received: from 136-022.dsl.labridge.com ([206.117.136.22]:2367 "EHLO
	mail.perches.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1760230AbYCWIMA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 04:12:00 -0400
From: Joe Perches <joe@perches.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 086/148] include/asm-x86/parport.h: checkpatch cleanups - formatting only
Date: Sun, 23 Mar 2008 01:03:01 -0700
Message-Id: <1206259443-13210-87-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.4.rc2
In-Reply-To: <1206259443-13210-1-git-send-email-joe@perches.com>
References: <1206259443-13210-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 include/asm-x86/parport.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/asm-x86/parport.h b/include/asm-x86/parport.h
index 019cbca..3c4ffeb 100644
--- a/include/asm-x86/parport.h
+++ b/include/asm-x86/parport.h
@@ -1,10 +1,10 @@
 #ifndef _ASM_X86_PARPORT_H
 #define _ASM_X86_PARPORT_H
 
-static int __devinit parport_pc_find_isa_ports (int autoirq, int autodma);
-static int __devinit parport_pc_find_nonpci_ports (int autoirq, int autodma)
+static int __devinit parport_pc_find_isa_ports(int autoirq, int autodma);
+static int __devinit parport_pc_find_nonpci_ports(int autoirq, int autodma)
 {
-	return parport_pc_find_isa_ports (autoirq, autodma);
+	return parport_pc_find_isa_ports(autoirq, autodma);
 }
 
 #endif /* _ASM_X86_PARPORT_H */
-- 
1.5.4.rc2


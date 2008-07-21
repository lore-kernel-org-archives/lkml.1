Return-Path: <linux-kernel-owner+w=401wt.eu-S1758260AbYGUAKX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260AbYGUAKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:10:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757722AbYGUAFF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:05:05 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58664 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757730AbYGUAFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:05:03 -0400
Subject: [PATCH 22/22] xtensa: Introducing asm/syscalls.h
From: Jaswinder Singh <jaswinder@infradead.org>
To: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, chris@zankel.net
In-Reply-To: <1216598318.3679.151.camel@jaswinder.satnam>
References: <1216592500.3679.14.camel@jaswinder.satnam>
	 <1216592798.3679.22.camel@jaswinder.satnam>
	 <1216592879.3679.24.camel@jaswinder.satnam>
	 <1216593035.3679.27.camel@jaswinder.satnam>
	 <1216596035.3679.95.camel@jaswinder.satnam>
	 <1216596106.3679.98.camel@jaswinder.satnam>
	 <1216596325.3679.104.camel@jaswinder.satnam>
	 <1216596669.3679.112.camel@jaswinder.satnam>
	 <1216596749.3679.115.camel@jaswinder.satnam>
	 <1216596835.3679.117.camel@jaswinder.satnam>
	 <1216596932.3679.120.camel@jaswinder.satnam>
	 <1216597066.3679.123.camel@jaswinder.satnam>
	 <1216597151.3679.125.camel@jaswinder.satnam>
	 <1216597237.3679.128.camel@jaswinder.satnam>
	 <1216597352.3679.131.camel@jaswinder.satnam>
	 <1216597566.3679.135.camel@jaswinder.satnam>
	 <1216597856.3679.139.camel@jaswinder.satnam>
	 <1216597923.3679.141.camel@jaswinder.satnam>
	 <1216597993.3679.144.camel@jaswinder.satnam>
	 <1216598067.3679.146.camel@jaswinder.satnam>
	 <1216598151.3679.148.camel@jaswinder.satnam>
	 <1216598318.3679.151.camel@jaswinder.satnam>
Content-Type: text/plain
Date: Mon, 21 Jul 2008 05:30:08 +0530
Message-Id: <1216598408.3679.154.camel@jaswinder.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Declaring arch-dependent syscalls for xtensa architecture

Signed-off-by: Jaswinder Singh <jaswinder@infradead.org>
---
 include/asm-xtensa/syscalls.h |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/include/asm-xtensa/syscalls.h b/include/asm-xtensa/syscalls.h
index e69de29..4aa949e 100644
--- a/include/asm-xtensa/syscalls.h
+++ b/include/asm-xtensa/syscalls.h
@@ -0,0 +1,17 @@
+/*
+ * syscalls.h - Linux syscall interfaces (arch-specific)
+ *
+ * Copyright (c) 2008 Jaswinder Singh
+ *
+ * This file is released under the GPLv2.
+ * See the file COPYING for more details.
+ *
+ * Please do not call me directly, include linux/syscalls.h
+ */
+
+#ifndef _ASM_XTENSA_SYSCALLS_H
+#define _ASM_XTENSA_SYSCALLS_H
+
+/* define arch dependent syscalls here */
+
+#endif /* _ASM_XTENSA_SYSCALLS_H */
-- 
1.5.5.1




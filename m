Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbYGPVba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbYGPVba (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 17:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYGPVbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 17:31:21 -0400
Received: from www.tglx.de ([62.245.132.106]:42256 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115AbYGPVbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 17:31:20 -0400
Date: Wed, 16 Jul 2008 23:31:17 +0200
From: Sebastian Siewior <bigeasy@linutronix.de>
To: Steven Rostedt <srostedt@redhat.co>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] ftrace: copy + paste typo in asm/ftrace.h
Message-ID: <20080716213117.GA27890@www.tglx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sebastian Siewior <bigeasy@linutronix.de>
---
 include/asm-x86/ftrace.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/asm-x86/ftrace.h b/include/asm-x86/ftrace.h
index c184441..5c68b32 100644
--- a/include/asm-x86/ftrace.h
+++ b/include/asm-x86/ftrace.h
@@ -1,5 +1,5 @@
 #ifndef _ASM_X86_FTRACE
-#define _ASM_SPARC64_FTRACE
+#define _ASM_X86_FTRACE
 
 #ifdef CONFIG_FTRACE
 #define MCOUNT_ADDR		((long)(mcount))
-- 
1.5.5.2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1756833AbZHZGge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833AbZHZGge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZHZGgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:36:32 -0400
Received: from 124-219-29-227.vdslpro.static.apol.com.tw ([124.219.29.227]:43201
	"EHLO mswedge2.sunplus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756806AbZHZGgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:36:31 -0400
Subject: Subject: [PATCH 19/33] score: create head files ipcbuf.h msgbuf.h
	sembuf.h shmparam.h shmbuf.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:25:49 +0800
Message-Id: <1251267949.3153.5.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 02242e99bbb6cb954d62b231538f81bdf71958b5 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:05 +0800
Subject: [PATCH 19/33] score: create head files ipcbuf.h msgbuf.h sembuf.h shmparam.h shmbuf.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/ipcbuf.h   |    6 ++++++
 arch/score/include/asm/msgbuf.h   |    6 ++++++
 arch/score/include/asm/sembuf.h   |    6 ++++++
 arch/score/include/asm/shmbuf.h   |    6 ++++++
 arch/score/include/asm/shmparam.h |    6 ++++++
 5 files changed, 30 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/ipcbuf.h
 create mode 100644 arch/score/include/asm/msgbuf.h
 create mode 100644 arch/score/include/asm/sembuf.h
 create mode 100644 arch/score/include/asm/shmbuf.h
 create mode 100644 arch/score/include/asm/shmparam.h

diff --git a/arch/score/include/asm/ipcbuf.h b/arch/score/include/asm/ipcbuf.h
new file mode 100644
index 0000000..e082cef
--- /dev/null
+++ b/arch/score/include/asm/ipcbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_IPCBUF_H
+#define _ASM_SCORE_IPCBUF_H
+
+#include <asm-generic/ipcbuf.h>
+
+#endif /* _ASM_SCORE_IPCBUF_H */
diff --git a/arch/score/include/asm/msgbuf.h b/arch/score/include/asm/msgbuf.h
new file mode 100644
index 0000000..7506721
--- /dev/null
+++ b/arch/score/include/asm/msgbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_MSGBUF_H
+#define _ASM_SCORE_MSGBUF_H
+
+#include <asm-generic/msgbuf.h>
+
+#endif /* _ASM_SCORE_MSGBUF_H */
diff --git a/arch/score/include/asm/sembuf.h b/arch/score/include/asm/sembuf.h
new file mode 100644
index 0000000..dae5e83
--- /dev/null
+++ b/arch/score/include/asm/sembuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SEMBUF_H
+#define _ASM_SCORE_SEMBUF_H
+
+#include <asm-generic/sembuf.h>
+
+#endif /* _ASM_SCORE_SEMBUF_H */
diff --git a/arch/score/include/asm/shmbuf.h b/arch/score/include/asm/shmbuf.h
new file mode 100644
index 0000000..c85b242
--- /dev/null
+++ b/arch/score/include/asm/shmbuf.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SHMBUF_H
+#define _ASM_SCORE_SHMBUF_H
+
+#include <asm-generic/shmbuf.h>
+
+#endif /* _ASM_SCORE_SHMBUF_H */
diff --git a/arch/score/include/asm/shmparam.h b/arch/score/include/asm/shmparam.h
new file mode 100644
index 0000000..1d60813
--- /dev/null
+++ b/arch/score/include/asm/shmparam.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_SHMPARAM_H
+#define _ASM_SCORE_SHMPARAM_H
+
+#include <asm-generic/shmparam.h>
+
+#endif /* _ASM_SCORE_SHMPARAM_H */
-- 
1.6.2




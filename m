Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbZHZGnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbZHZGnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 02:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZHZGnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 02:43:20 -0400
Received: from 60-248-182-106.HINET-IP.hinet.net ([60.248.182.106]:57226 "EHLO
	mswedge2.sunplus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754170AbZHZGnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 02:43:20 -0400
Subject: Subject: [PATCH 09/33] score: create head files fcntl.h poll.h
	stat.h statfs.h termbits.h termios.h
From: Chen Liqin <liqin.chen@sunplusct.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, torvalds@linux-foundation.org
Content-Type: text/plain
Date: Wed, 26 Aug 2009 14:14:30 +0800
Message-Id: <1251267270.3073.9.camel@ad3ser01>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27.rhel4.6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 96856b45521f413e931760a15643faf4dcba9af9 Mon Sep 17 00:00:00 2001
From: Chen Liqin <liqin.chen@sunplusct.com>
Date: Wed, 26 Aug 2009 10:05:00 +0800
Subject: [PATCH 09/33] score: create head files fcntl.h poll.h stat.h statfs.h termbits.h termios.h


Signed-off-by: Chen Liqin <liqin.chen@sunplusct.com>
---
 arch/score/include/asm/fcntl.h    |    6 ++++++
 arch/score/include/asm/poll.h     |    6 ++++++
 arch/score/include/asm/stat.h     |    6 ++++++
 arch/score/include/asm/statfs.h   |    6 ++++++
 arch/score/include/asm/termbits.h |    6 ++++++
 arch/score/include/asm/termios.h  |    6 ++++++
 6 files changed, 36 insertions(+), 0 deletions(-)
 create mode 100644 arch/score/include/asm/fcntl.h
 create mode 100644 arch/score/include/asm/poll.h
 create mode 100644 arch/score/include/asm/stat.h
 create mode 100644 arch/score/include/asm/statfs.h
 create mode 100644 arch/score/include/asm/termbits.h
 create mode 100644 arch/score/include/asm/termios.h

diff --git a/arch/score/include/asm/fcntl.h b/arch/score/include/asm/fcntl.h
new file mode 100644
index 0000000..03968a3
--- /dev/null
+++ b/arch/score/include/asm/fcntl.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_FCNTL_H
+#define _ASM_SCORE_FCNTL_H
+
+#include <asm-generic/fcntl.h>
+
+#endif /* _ASM_SCORE_FCNTL_H */
diff --git a/arch/score/include/asm/poll.h b/arch/score/include/asm/poll.h
new file mode 100644
index 0000000..18532db
--- /dev/null
+++ b/arch/score/include/asm/poll.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_POLL_H
+#define _ASM_SCORE_POLL_H
+
+#include <asm-generic/poll.h>
+
+#endif /* _ASM_SCORE_POLL_H */
diff --git a/arch/score/include/asm/stat.h b/arch/score/include/asm/stat.h
new file mode 100644
index 0000000..5037055
--- /dev/null
+++ b/arch/score/include/asm/stat.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_STAT_H
+#define _ASM_SCORE_STAT_H
+
+#include <asm-generic/stat.h>
+
+#endif /* _ASM_SCORE_STAT_H */
diff --git a/arch/score/include/asm/statfs.h b/arch/score/include/asm/statfs.h
new file mode 100644
index 0000000..36e4100
--- /dev/null
+++ b/arch/score/include/asm/statfs.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_STATFS_H
+#define _ASM_SCORE_STATFS_H
+
+#include <asm-generic/statfs.h>
+
+#endif /* _ASM_SCORE_STATFS_H */
diff --git a/arch/score/include/asm/termbits.h b/arch/score/include/asm/termbits.h
new file mode 100644
index 0000000..9a95c14
--- /dev/null
+++ b/arch/score/include/asm/termbits.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TERMBITS_H
+#define _ASM_SCORE_TERMBITS_H
+
+#include <asm-generic/termbits.h>
+
+#endif /* _ASM_SCORE_TERMBITS_H */
diff --git a/arch/score/include/asm/termios.h b/arch/score/include/asm/termios.h
new file mode 100644
index 0000000..40984e8
--- /dev/null
+++ b/arch/score/include/asm/termios.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_SCORE_TERMIOS_H
+#define _ASM_SCORE_TERMIOS_H
+
+#include <asm-generic/termios.h>
+
+#endif /* _ASM_SCORE_TERMIOS_H */
-- 
1.6.2




Return-Path: <linux-kernel-owner+w=401wt.eu-S1753827AbZIXSml@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbZIXSml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 14:42:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752992AbZIXSl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 14:41:58 -0400
Received: from mail.perches.com ([173.55.12.10]:1153 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753358AbZIXSl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 14:41:56 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 02/11] MAINTAINERS: Update TRACING section
Date: Thu, 24 Sep 2009 11:41:50 -0700
Message-Id: <0473ff3762dd588cc23419d8386de1486f63c02c.1253817463.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1253817463.git.joe@perches.com>
References: <cover.1253817463.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move to alphabetic position
Use single line F: entries

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f8cea20..87bfe9c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2166,18 +2166,6 @@ F:	Documentation/filesystems/caching/
 F:	fs/fscache/
 F:	include/linux/fscache*.h
 
-TRACING
-M:	Steven Rostedt <rostedt@goodmis.org>
-M:	Frederic Weisbecker <fweisbec@gmail.com>
-M:	Ingo Molnar <mingo@redhat.com>
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
-S:	Maintained
-F:	Documentation/trace/ftrace.txt
-F:	arch/*/*/*/ftrace.h
-F:	arch/*/kernel/ftrace.c
-F:	include/*/ftrace.h include/trace/ include/linux/trace*.h
-F:	kernel/trace/
-
 FUJITSU FR-V (FRV) PORT
 M:	David Howells <dhowells@redhat.com>
 S:	Maintained
@@ -5115,6 +5103,20 @@ L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 F:	drivers/char/tpm/
 
+TRACING
+M:	Steven Rostedt <rostedt@goodmis.org>
+M:	Frederic Weisbecker <fweisbec@gmail.com>
+M:	Ingo Molnar <mingo@redhat.com>
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing/core
+S:	Maintained
+F:	Documentation/trace/ftrace.txt
+F:	arch/*/*/*/ftrace.h
+F:	arch/*/kernel/ftrace.c
+F:	include/*/ftrace.h
+F:	include/linux/trace*.h
+F:	include/trace/
+F:	kernel/trace/
+
 TRIVIAL PATCHES
 M:	Jiri Kosina <trivial@kernel.org>
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git
-- 
1.6.3.1.10.g659a0.dirty


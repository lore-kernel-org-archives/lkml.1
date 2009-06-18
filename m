Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbZFRSIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbZFRSIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 14:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZFRSIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 14:08:09 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1514 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439AbZFRSIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 14:08:05 -0400
From: Joe Perches <joe@perches.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Steven Rostedt <rostedt@goodmis.org>, linux-doc@vger.kernel.org
Subject: [PATCH 2/5] MAINTAINERS: Update Ftrace documentation pattern
Date: Thu, 18 Jun 2009 11:08:02 -0700
Message-Id: <11ede688abc619559ed76f8f014815cf71f3b07a.1245345515.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245345515.git.joe@perches.com>
References: <cover.1245345515.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4e73646..d9b3665 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2391,7 +2391,7 @@ FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org
 S:	Maintained
-F:	Documentation/ftrace.txt
+F:	Documentation/trace/ftrace.txt
 F:	arch/*/*/*/ftrace.h
 F:	arch/*/kernel/ftrace.c
 F:	include/*/ftrace.h
-- 
1.6.3.1.10.g659a0.dirty


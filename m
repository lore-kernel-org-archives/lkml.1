Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbZAMU3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbZAMU3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 15:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758524AbZAMU1v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 15:27:51 -0500
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:2534 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923AbZAMU1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 15:27:50 -0500
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 08/10] MAINTAINERS - Add FTRACE git
Date: Tue, 13 Jan 2009 12:28:16 -0800
Message-Id: <1231878498-25171-9-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1231878498-25171-1-git-send-email-joe@perches.com>
References: <1231878498-25171-1-git-send-email-joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 MAINTAINERS |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index ceeeb8c..6e051c3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2189,6 +2189,7 @@ F:	fs/freevxfs/
 FTRACE
 P:	Steven Rostedt
 M:	rostedt@goodmis.org
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/x86/linux-2.6-tip.git
 S:	Maintained
 F:	Documentation/ftrace.txt
 F:	arch/*/*/*/ftrace.h
-- 
1.6.0.2


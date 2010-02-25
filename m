Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933975Ab0BYV2j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 16:28:39 -0500
Received: from mail.windriver.com ([147.11.1.11]:63598 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933847Ab0BYVWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 16:22:35 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 25/28] MAINTAINERS: update kgdb, kdb, and debug_core info
Date: Thu, 25 Feb 2010 15:21:30 -0600
Message-Id: <1267132893-23624-26-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
References: <1267132893-23624-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 25 Feb 2010 21:22:02.0602 (UTC) FILETIME=[9297D4A0:01CAB660]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintained files sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2533fc4..fcdc701 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3171,15 +3171,18 @@ S:	Maintained
 F:	include/linux/kexec.h
 F:	kernel/kexec.c
 
-KGDB
+KGDB / KDB / debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
+W:	http://kgdb.wiki.kernel.org/
 L:	kgdb-bugreport@lists.sourceforge.net
 S:	Maintained
 F:	Documentation/DocBook/kgdb.tmpl
+F:	drivers/char/kdb_keyboard.*
 F:	drivers/misc/kgdbts.c
 F:	drivers/serial/kgdboc.c
 F:	include/linux/kgdb.h
-F:	kernel/kgdb.c
+F:	include/linux/kdb.h
+F:	kernel/debug/
 
 KMEMCHECK
 M:	Vegard Nossum <vegardno@ifi.uio.no>
-- 
1.6.4.rc1


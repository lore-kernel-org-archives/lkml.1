Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757760Ab0BLWj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Feb 2010 17:39:27 -0500
Received: from mail.windriver.com ([147.11.1.11]:44125 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757648Ab0BLWge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Feb 2010 17:36:34 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 25/28] MAINTAINERS: update kgdb, kdb, and debug_core info
Date: Fri, 12 Feb 2010 16:35:40 -0600
Message-Id: <1266014143-29444-26-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
References: <1266014143-29444-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 12 Feb 2010 22:36:25.0926 (UTC) FILETIME=[CF924660:01CAAC33]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintained files sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 412eff6..b7b192a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3172,15 +3172,17 @@ S:	Maintained
 F:	include/linux/kexec.h
 F:	kernel/kexec.c
 
-KGDB
+KGDB / KDB / debug_core
 M:	Jason Wessel <jason.wessel@windriver.com>
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


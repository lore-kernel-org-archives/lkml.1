Return-Path: <linux-kernel-owner+w=401wt.eu-S932074AbZLWV0v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074AbZLWV0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 16:26:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754157AbZLWV0h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 16:26:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:45110 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZLWVUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 16:20:43 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, kdb@oss.sgi.com, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 29/37] MAINTAINERS: update kgdb, kdb, and debug_core info
Date: Wed, 23 Dec 2009 15:19:42 -0600
Message-Id: <1261603190-5036-30-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1261603190-5036-29-git-send-email-jason.wessel@windriver.com>
References: <1261603190-5036-1-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-2-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-3-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-4-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-5-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-6-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-7-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-8-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-9-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-10-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-11-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-12-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-13-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-14-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-15-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-16-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-17-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-18-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-19-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-20-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-21-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-22-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-23-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-24-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-25-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-26-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-27-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-28-git-send-email-jason.wessel@windriver.com>
 <1261603190-5036-29-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 23 Dec 2009 21:20:30.0286 (UTC) FILETIME=[C12186E0:01CA8415]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintained files sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index d5244f1..98b2669 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3177,15 +3177,17 @@ S:	Maintained
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


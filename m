Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998Ab0ANPFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab0ANPFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 10:05:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932238Ab0ANPFT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 10:05:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:47778 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756607Ab0ANPBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 10:01:19 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: linux-kernel@vger.kernel.org
Cc: kgdb-bugreport@lists.sourceforge.net, mingo@elte.hu,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 29/40] MAINTAINERS: update kgdb, kdb, and debug_core info
Date: Thu, 14 Jan 2010 08:59:25 -0600
Message-Id: <1263481176-1897-30-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.3.1.9.g95405b
In-Reply-To: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 14 Jan 2010 15:01:05.0085 (UTC) FILETIME=[651A06D0:01CA952A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the maintained files sections.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 MAINTAINERS |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c8f47bf..88f4741 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3174,15 +3174,17 @@ S:	Maintained
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
1.6.3.1.9.g95405b


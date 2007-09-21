Return-Path: <linux-kernel-owner+w=401wt.eu-S1760979AbXIUSms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760979AbXIUSms (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 14:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756925AbXIUSmm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 14:42:42 -0400
Received: from zaphod.dth.net ([85.159.112.68]:35649 "EHLO zaphod.dth.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756646AbXIUSmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 14:42:42 -0400
Date: Fri, 21 Sep 2007 20:42:36 +0200
From: Danny ter Haar <dth@dth.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: typo fix Kernel config option
Message-ID: <20070921184236.GA12584@dth.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--- lib/Kconfig.debug.orig      2007-09-21 20:40:08.544353283 +0200
+++ lib/Kconfig.debug   2007-09-21 20:40:33.478816660 +0200
@@ -284,7 +284,7 @@
        select KALLSYMS_ALL
 
 config LOCK_STAT
-       bool "Lock usage statisitics"
+       bool "Lock usage statistics"
        depends on DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT
        select LOCKDEP
        select DEBUG_SPINLOCK


-- 
The five R's of windows tech support: Retry, Reboot, Reinstall, Replace & Resign

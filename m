Return-Path: <linux-kernel-owner+w=401wt.eu-S1422693AbXDCUVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422693AbXDCUVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945905AbXDCUVP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:21:15 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51288 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422693AbXDCUVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:21:14 -0400
X-AuthUser: davidel@xmailserver.org
From: Davide Libenzi <davidel@xmailserver.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 03 Apr 2007 13:21:11 -0700
Subject: [patch 2/5] new fds fixes for 2.6.21-rc5.mm4 - fix a spelling error ...
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Message-ID: <send-serie.davidel@xmailserver.org.27063.1175631672.2>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes a spelling error inside init/Kconfig.



Signed-off-by: Davide Libenzi <davidel@xmailserver.org>


- Davide


Index: linux-2.6.21-rc5.mm4/init/Kconfig
===================================================================
--- linux-2.6.21-rc5.mm4.orig/init/Kconfig	2007-04-03 13:17:25.000000000 -0700
+++ linux-2.6.21-rc5.mm4/init/Kconfig	2007-04-03 13:17:35.000000000 -0700
@@ -479,7 +479,7 @@
 	  run glibc-based applications correctly.
 
 config ANON_INODES
-	bool "Enable anynimous inode source" if EMBEDDED
+	bool "Enable anonymous inode source" if EMBEDDED
 	default y
 	help
 	  Anonymous inode source for pseudo-files like epoll, signalfd,


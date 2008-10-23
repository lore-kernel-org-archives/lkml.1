Return-Path: <linux-kernel-owner+w=401wt.eu-S1759130AbYJWXLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759130AbYJWXLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758237AbYJWXKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:10 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4767 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756369AbYJWXJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:43 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 5/8] MAINTAINERS - Remove HP Fibre Channel HBA no longer in tree
Date: Thu, 23 Oct 2008 16:09:23 -0700
Message-Id: <92e881c3c6b7068ee07f8415be9071cfcea2175c.1224802312.git.joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
 <f3c9f31c59a20acbc8b7535878ab6c86ba6630de.1224802312.git.joe@perches.com>
 <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
 <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 797602e..c74ce8b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2264,46 +2264,40 @@ HARDWARE RANDOM NUMBER GENERATOR CORE
 S:	Orphan
 F:	Documentation/hw_random.txt
 F:	drivers/char/hw_random/
 F:	include/linux/hw_random.h
 
 HARMONY SOUND DRIVER
 P:	Kyle McMartin
 M:	kyle@mcmartin.ca
 L:	linux-parisc@vger.kernel.org
 S:	Maintained
 F:	sound/parisc/harmony.*
 
 HAYES ESP SERIAL DRIVER
 P:	Andrew J. Robinson
 M:	arobinso@nyx.net
 L:	linux-kernel@vger.kernel.org
 W:	http://www.nyx.net/~arobinso
 S:	Maintained
 F:	drivers/char/esp.c
 
-HEWLETT-PACKARD FIBRE CHANNEL 64-bit/66MHz PCI non-intelligent HBA
-P:	Chirag Kantharia
-M:	chirag.kantharia@hp.com
-L:	iss_storagedev@hp.com
-S:	Maintained
-
 HEWLETT-PACKARD SMART2 RAID DRIVER
 P:	Chirag Kantharia
 M:	chirag.kantharia@hp.com
 L:	iss_storagedev@hp.com
 S:	Maintained
 F:	drivers/block/cpqarray.*
 
 HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
 P:	Mike Miller
 M:	mike.miller@hp.com
 L:	iss_storagedev@hp.com
 S:	Supported
 F:	Documentation/cciss.txt
 F:	drivers/block/cciss*
 F:	include/linux/cciss_ioctl.h
 
 HFS FILESYSTEM
 P:	Roman Zippel
 M:	zippel@linux-m68k.org
 L:	linux-kernel@vger.kernel.org
-- 
1.6.0.2


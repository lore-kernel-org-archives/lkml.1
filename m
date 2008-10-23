Return-Path: <linux-kernel-owner+w=401wt.eu-S1759283AbYJWXM0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283AbYJWXM0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:12:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754255AbYJWXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:19 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4769 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbYJWXJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:48 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 7/8] MAINTAINERS - Add Linus Torvalds' git
Date: Thu, 23 Oct 2008 16:09:25 -0700
Message-Id: <fbea7757e53ac2eb8fe950ce703f2168c6c68d36.1224802312.git.joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <1a29dd9705091501c849a7c96678aa1a4796a836.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
 <f3c9f31c59a20acbc8b7535878ab6c86ba6630de.1224802312.git.joe@perches.com>
 <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
 <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
 <92e881c3c6b7068ee07f8415be9071cfcea2175c.1224802312.git.joe@perches.com>
 <1a29dd9705091501c849a7c96678aa1a4796a836.1224802312.git.joe@perches.com>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fdda380..99c5080 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5842,20 +5842,21 @@ L:	zd1211-devs@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 F:	drivers/net/wireless/zd1211rw/
 
 ZR36067 VIDEO FOR LINUX DRIVER
 P:	Ronald Bultje
 M:	rbultje@ronald.bitfreak.net
 L:	mjpeg-users@lists.sourceforge.net
 W:	http://mjpeg.sourceforge.net/driver-zoran/
 S:	Maintained
 F:	drivers/media/video/zoran/
 
 ZS DECSTATION Z85C30 SERIAL DRIVER
 P:	Maciej W. Rozycki
 M:	macro@linux-mips.org
 S:	Maintained
 F:	drivers/serial/zs.*
 
 THE REST
 P:	Linus Torvalds
 S:	Buried alive in reporters
+T:	git git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
-- 
1.6.0.2


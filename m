Return-Path: <linux-kernel-owner+w=401wt.eu-S1758984AbYJWXL2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758984AbYJWXL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 19:11:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbYJWXKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 19:10:08 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:4765 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYJWXJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 19:09:42 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <randy.dunlap@oracle.com>, Pavel Machek <pavel@suse.cz>,
       =?utf-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@strlen.de>
Subject: [PATCH 4/8] MAINTAINERS - remove CS4280
Date: Thu, 23 Oct 2008 16:09:22 -0700
Message-Id: <61cf615d8a20ad2608cb1c2fbad67ff4253a8457.1224802312.git.joe@perches.com>
X-Mailer: git-send-email 1.6.0.2
In-Reply-To: <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
References: <1224803366-6478-1-git-send-email-joe@perches.com>
 <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
 <f3c9f31c59a20acbc8b7535878ab6c86ba6630de.1224802312.git.joe@perches.com>
 <f1526bde1c026c2b5f439a97f96ec587705229e5.1224802312.git.joe@perches.com>
In-Reply-To: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
References: <ab48bcafb1ceab1c0d53e93781605603cfabf6dc.1224802312.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unsupported Cirrus Logic CS4280 driver

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index af86eb6..797602e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1283,49 +1283,40 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC EP93XX OHCI USB HOST DRIVER
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	linux-usb@vger.kernel.org
 S:	Maintained
 F:	drivers/usb/host/ohci-ep93xx.c
 
 CIRRUS LOGIC CS4270 SOUND DRIVER
 P:	Timur Tabi
 M:	timur@freescale.com
 L:	alsa-devel@alsa-project.org
 S:	Supported
 F:	sound/soc/codecs/cs4270*
 F:	sound/soc/fsl/mpc8610_hpcd.c
 
-CIRRUS LOGIC CS4280/CS461x SOUNDDRIVER
-P:	Cirrus Logic Corporation (kernel 2.2 driver)
-M:	Cirrus Logic Corporation, Thomas Woller <twoller@crystal.cirrus.com>
-P:	Nils Faerber (port to kernel 2.4)
-M:	Nils Faerber <nils@kernelconcepts.de>
-S:	Maintained
-F:	Documentation/input/cs461x.txt
-F:	sound/pci/cs46xx/
-
 CODA FILE SYSTEM
 P:	Jan Harkes
 M:	jaharkes@cs.cmu.edu
 M:	coda@cs.cmu.edu
 L:	codalist@coda.cs.cmu.edu
 W:	http://www.coda.cs.cmu.edu/
 S:	Maintained
 F:	fs/coda/
 F:	include/linux/coda*.h
 
 COMMON INTERNET FILE SYSTEM (CIFS)
 P:	Steve French
 M:	sfrench@samba.org
 L:	linux-cifs-client@lists.samba.org
 L:	samba-technical@lists.samba.org
 W:	http://linux-cifs.samba.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/sfrench/cifs-2.6.git
 S:	Supported
 F:	fs/cifs/
 
-- 
1.6.0.2


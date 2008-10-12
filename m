Return-Path: <linux-kernel-owner+w=401wt.eu-S1754394AbYJLXMz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754394AbYJLXMz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 19:12:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYJLXMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 19:12:42 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:43486 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157AbYJLXMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 19:12:41 -0400
Date: Sun, 12 Oct 2008 16:11:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] MAINTAINERS: add F: and acronyms
Message-Id: <20081012161145.6bf0a685.randy.dunlap@oracle.com>
In-Reply-To: <alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
References: <20081010235755.12643.43818.stgit@warthog.procyon.org.uk>
	<alpine.LFD.2.00.0810121245260.3402@nehalem.linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Add F: definition since it is being used.

Expand acronyms or add them so that users of MAINTAINERS file can find
entries more easily.

Correct driver spelling.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |   17 +++++++++--------
 1 file changed, 9 insertions(+), 8 deletions(-)

--- lin2627-g2-maint.orig/MAINTAINERS
+++ lin2627-g2-maint/MAINTAINERS
@@ -73,6 +73,7 @@ L: Mailing list that is relevant to this
 W: Web-page with status/info
 T: SCM tree type and location.  Type is one of: git, hg, quilt.
 S: Status, one of the following:
+F: Applicable files and/or directories
 
 	Supported:	Someone is actually paid to look after this.
 	Maintained:	Someone actually looks after it.
@@ -718,7 +719,7 @@ L:	linux-kernel@vger.kernel.org
 W:	http://sourceforge.net/projects/xscaleiop
 S:	Supported
 
-ATA OVER ETHERNET DRIVER
+ATA OVER ETHERNET (AOE) DRIVER
 P:	Ed L. Cashin
 M:	ecashin@coraid.com
 W:	http://www.coraid.com/support/linux
@@ -1371,7 +1372,7 @@ L:	Eng.Linux@digi.com
 W:	http://www.digi.com
 S:	Orphan
 
-DIRECTORY NOTIFICATION
+DIRECTORY NOTIFICATION (DNOTIFY)
 P:	Stephen Rothwell
 M:	sfr@canb.auug.org.au
 L:	linux-kernel@vger.kernel.org
@@ -1391,7 +1392,7 @@ M:	jack@suse.cz
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
-DISTRIBUTED LOCK MANAGER
+DISTRIBUTED LOCK MANAGER (DLM)
 P:	Christine Caulfield
 M:	ccaulfie@redhat.com
 P:	David Teigland
@@ -2293,7 +2294,7 @@ L:	netdev@vger.kernel.org
 L:	lvs-devel@vger.kernel.org
 S:	Maintained
 
-IPWIRELES DRIVER
+IPWIRELESS DRIVER
 P:	Jiri Kosina
 M:	jkosina@suse.cz
 P:	David Sterba
@@ -3419,7 +3420,7 @@ M:	paulus@samba.org
 L:	linux-fbdev-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
 
-RALINK RT2X00 WLAN DRIVER
+RALINK RT2X00 WIRELESS LAN DRIVER
 P:	rt2x00 project
 L:	linux-wireless@vger.kernel.org
 L:	rt2400-devel@lists.sourceforge.net
@@ -3652,7 +3653,7 @@ M:	saschasommer@freenet.de
 L:	sdricohcs-devel@lists.sourceforge.net (subscribers-only)
 S:	Maintained
 
-SECURE DIGITAL HOST CONTROLLER INTERFACE DRIVER
+SECURE DIGITAL HOST CONTROLLER INTERFACE (SDHCI) DRIVER
 P:	Pierre Ossman
 M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
@@ -4450,7 +4451,7 @@ L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 
-USER-MODE LINUX
+USER-MODE LINUX (UML)
 P:	Jeff Dike
 M:	jdike@addtoit.com
 L:	user-mode-linux-devel@lists.sourceforge.net
@@ -4497,7 +4498,7 @@ M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
 
-VIDEO FOR LINUX
+VIDEO FOR LINUX (V4L)
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
 M:	v4l-dvb-maintainer@linuxtv.org

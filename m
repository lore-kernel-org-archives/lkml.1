Return-Path: <linux-kernel-owner+w=401wt.eu-S1161383AbXBOVa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383AbXBOVa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161387AbXBOVa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:30:29 -0500
Received: from agminet01.oracle.com ([141.146.126.228]:26635 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161383AbXBOVa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:30:28 -0500
Date: Thu, 15 Feb 2007 13:25:49 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@osdl.org>, linux-fbdev-devel@lists.sourceforge.net
Subject: [PATCH] MAINTAINERS: mark framebuffer as Orphan
Message-Id: <20070215132549.c182f7bf.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Are we ready to do this?
I'd love for Tony to return, but he's been missing for awhile now.

So this give us the following major areas that are marked as Orphan:

Firmware loader
Framebuffer
Serial (8250/16x50)

and PCMCIA has a Team.  It doesn't seem to be hurting.  :)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- linux-2.6.20-git9.orig/MAINTAINERS
+++ linux-2.6.20-git9/MAINTAINERS
@@ -1321,11 +1321,9 @@ W:	http://www.farsite.co.uk/
 S:	Supported
 
 FRAMEBUFFER LAYER
-P:	Antonino Daplas
-M:	adaplas@pol.net
 L:	linux-fbdev-devel@lists.sourceforge.net (subscribers-only)
 W:	http://linux-fbdev.sourceforge.net/
-S:	Maintained
+S:	Orphan
 
 FREESCALE SOC FS_ENET DRIVER
 P:	Pantelis Antoniou

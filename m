Return-Path: <linux-kernel-owner+w=401wt.eu-S969037AbXHMIwI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969037AbXHMIwI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:52:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966189AbXHMGar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4839 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966882AbXHMGan (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:43 -0400
Date: Sun, 12 Aug 2007 23:30:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: [PATCH] [268/2many] MAINTAINERS - ISDN SUBSYSTEM
Message-ID: <46bffa7f.QCXmunATTWTH4aW5%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ab9ba39..fc593da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2565,6 +2565,10 @@ L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.isdn4linux.de
 T:	git kernel.org:/pub/scm/linux/kernel/kkeil/isdn-2.6.git
 S:	Maintained
+F:	Documentation/isdn/
+F:	drivers/isdn/
+F:	include/linux/isdn.h
+F:	include/linux/isdn/
 
 ISDN SUBSYSTEM (Eicon active card driver)
 P:	Armin Schindler

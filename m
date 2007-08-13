Return-Path: <linux-kernel-owner+w=401wt.eu-S943981AbXHMLGD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943981AbXHMLGD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:06:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967377AbXHMGhb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2011 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967346AbXHMGhK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:10 -0400
Date: Sun, 12 Aug 2007 23:36:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mj@ucw.cz,
       linux-video@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [467/2many] MAINTAINERS - SVGA HANDLING
Message-ID: <46bffc09.olZ/JU6zLi5nghOY%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e0020d6..cde4be1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4440,6 +4440,9 @@ P:	Martin Mares
 M:	mj@ucw.cz
 L:	linux-video@atrey.karlin.mff.cuni.cz
 S:	Maintained
+F:	Documentation/svga.txt
+F:	drivers/video/svgalib.c
+F:	include/linux/svga.h
 
 SYSV FILESYSTEM
 P:	Christoph Hellwig

Return-Path: <linux-kernel-owner+w=401wt.eu-S969825AbXHMIeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969825AbXHMIeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:34:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966677AbXHMG3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4677 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966596AbXHMG3k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:40 -0400
Date: Sun, 12 Aug 2007 23:29:24 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       aul@paulbristow.net, akpm@linux-foundation.org
Subject: [PATCH] [242/2many] MAINTAINERS - IDE/ATAPI FLOPPY DRIVERS
Message-ID: <46bffa44.KQJSADpo9NEunXpw%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b77decd..2f50f0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2290,10 +2290,11 @@ F:	drivers/ide/ide-cd.*
 
 IDE/ATAPI FLOPPY DRIVERS
 P:	Paul Bristow
-M:	Paul Bristow <paul@paulbristow.net>
+M:	aul@paulbristow.net
 W:	http://paulbristow.net/linux/idefloppy.html
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-floppy.c
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman

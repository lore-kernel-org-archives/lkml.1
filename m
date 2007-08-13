Return-Path: <linux-kernel-owner+w=401wt.eu-S969868AbXHMIed@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969868AbXHMIed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:34:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966598AbXHMG3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:44 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4682 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966386AbXHMG3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:42 -0400
Date: Sun, 12 Aug 2007 23:29:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       gadio@netvision.net.il, akpm@linux-foundation.org
Subject: [PATCH] [243/2many] MAINTAINERS - IDE/ATAPI TAPE DRIVERS
Message-ID: <46bffa46.LB42dQmqIBOhR2TN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2f50f0f..2063c0f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2298,9 +2298,10 @@ F:	drivers/ide/ide-floppy.c
 
 IDE/ATAPI TAPE DRIVERS
 P:	Gadi Oxman
-M:	Gadi Oxman <gadio@netvision.net.il>
+M:	gadio@netvision.net.il
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	drivers/ide/ide-tape.c
 
 IEEE 1394 SUBSYSTEM
 P:	Ben Collins

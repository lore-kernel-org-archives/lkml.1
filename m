Return-Path: <linux-kernel-owner+w=401wt.eu-S942615AbXHMIvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942615AbXHMIvY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966097AbXHMGam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:42 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4826 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966845AbXHMGaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:39 -0400
Date: Sun, 12 Aug 2007 23:30:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mac@melware.de,
       linux-kernel@vger.kernel.org, isdn4linux@listserv.isdn4linux.de,
       akpm@linux-foundation.org
Subject: [PATCH] [269/2many] MAINTAINERS - ISDN SUBSYSTEM (Eicon active
 card driver)
Message-ID: <46bffa81.MVK8dRAmL3vSca0v%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fc593da..cbf6cdb 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2576,6 +2576,7 @@ M:	mac@melware.de
 L:	isdn4linux@listserv.isdn4linux.de
 W:	http://www.melware.de
 S:	Maintained
+F:	drivers/isdn/hardware/eicon/
 
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse

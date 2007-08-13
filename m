Return-Path: <linux-kernel-owner+w=401wt.eu-S942321AbXHMHjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942321AbXHMHjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966120AbXHMG0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:21 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4130 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965948AbXHMG0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:13 -0400
Date: Sun, 12 Aug 2007 23:25:34 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       cxacru@fire.lp0.eu, akpm@linux-foundation.org,
       accessrunner-general@lists.sourceforge.net
Subject: [PATCH] [133/2many] MAINTAINERS - CONEXANT ACCESSRUNNER USB
 DRIVER
Message-ID: <46bff95e.3/UvsFLGAGauZhiR%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 594881d..d0a436a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1287,6 +1287,7 @@ M:	cxacru@fire.lp0.eu
 L:	accessrunner-general@lists.sourceforge.net
 W:	http://accessrunner.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/atm/cxacru.c
 
 CORETEMP HARDWARE MONITORING DRIVER
 P:	Rudolf Marek

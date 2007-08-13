Return-Path: <linux-kernel-owner+w=401wt.eu-S937566AbXHMHAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937566AbXHMHAk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:00:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966076AbXHMGYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3756 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966071AbXHMGYH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:07 -0400
Date: Sun, 12 Aug 2007 23:23:45 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       chas@cmf.nrl.navy.mil, akpm@linux-foundation.org
Subject: [PATCH] [75/2many] MAINTAINERS - ATM
Message-ID: <46bff8f1.9b84KdpSJPuyeeS4%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d9d1bcc..a393f71 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -760,6 +760,8 @@ M:	chas@cmf.nrl.navy.mil
 L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
+F:	drivers/atm/
+F:	include/linux/atm*
 
 ATMEL AT91 MCI DRIVER
 P:	Nicolas Ferre

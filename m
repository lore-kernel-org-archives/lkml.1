Return-Path: <linux-kernel-owner+w=401wt.eu-S971095AbXHMJEs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971095AbXHMJEs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:04:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966932AbXHMGbW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4949 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966602AbXHMGbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:18 -0400
Date: Sun, 12 Aug 2007 23:30:59 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, starblue@users.sourceforge.net,
       linux-kernel@vger.kernel.org, legousb-devel@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [286/2many] MAINTAINERS - LEGO USB Tower driver
Message-ID: <46bffaa3.SM8uGoC6ubi8uzui%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5b8199d..836c58d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2747,6 +2747,7 @@ M:	starblue@users.sourceforge.net
 L:	legousb-devel@lists.sourceforge.net
 W:	http://legousb.sourceforge.net/
 S:	Maintained
+F:	drivers/usb/misc/legousbtower.c
 
 LINUX FOR IBM pSERIES (RS/6000)
 P:	Paul Mackerras

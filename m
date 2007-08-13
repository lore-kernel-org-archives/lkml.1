Return-Path: <linux-kernel-owner+w=401wt.eu-S971751AbXHMJUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971751AbXHMJUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967011AbXHMGcN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1130 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966948AbXHMGcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:10 -0400
Date: Sun, 12 Aug 2007 23:31:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, dwmw2@infradead.org,
       akpm@linux-foundation.org
Subject: [PATCH] [315/2many] MAINTAINERS - MEMORY TECHNOLOGY DEVICES (MTD)
Message-ID: <46bffada.F0PQakXR051Jg8U+%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c60699..e4aa236 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3034,6 +3034,9 @@ W:	http://www.linux-mtd.infradead.org/
 L:	linux-mtd@lists.infradead.org
 T:	git git://git.infradead.org/mtd-2.6.git
 S:	Maintained
+F:	drivers/mtd/
+F:	include/linux/mtd/
+F:	include/mtd/
 
 UNSORTED BLOCK IMAGES (UBI)
 P:	Artem Bityutskiy

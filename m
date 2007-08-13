Return-Path: <linux-kernel-owner+w=401wt.eu-S942643AbXHMLwu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942643AbXHMLwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:52:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967465AbXHMGjl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2392 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967409AbXHMGjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:39 -0400
Date: Sun, 12 Aug 2007 23:39:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, rio500-users@lists.sourceforge.net,
       miquel@df.uba.ar, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [533/2many] MAINTAINERS - USB DIAMOND RIO500 DRIVER
Message-ID: <46bffc9e.nuWmINVe0Y1xeuLl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b2f0e47..3e962b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5036,6 +5036,7 @@ M:	miquel@df.uba.ar
 L:	rio500-users@lists.sourceforge.net
 W:	http://rio500.sourceforge.net
 S:	Maintained
+F:	drivers/usb/misc/rio500*
 
 VIDEO FOR LINUX
 P:	Mauro Carvalho Chehab

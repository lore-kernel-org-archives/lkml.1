Return-Path: <linux-kernel-owner+w=401wt.eu-S968692AbXHMLgY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968692AbXHMLgY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:36:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939298AbXHMGis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:48 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2233 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965969AbXHMGin (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:43 -0400
Date: Sun, 12 Aug 2007 23:38:30 -0700
From: joe@perches.com
To: zaitcev@redhat.com, torvalds@linux-foundation.org,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [505/2many] MAINTAINERS - USB PRINTER DRIVER (usblp)
Message-ID: <46bffc66.diROOf5iG6C2+p1R%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fc87fa7..02bb359 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4772,6 +4772,7 @@ M:	zaitcev@redhat.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	/drivers/usb/class/usblp.c
 
 USB RTL8150 DRIVER
 P:	Petko Manolov

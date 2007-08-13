Return-Path: <linux-kernel-owner+w=401wt.eu-S943163AbXHMLoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943163AbXHMLoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967421AbXHMGjO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2312 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967235AbXHMGjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:12 -0400
Date: Sun, 12 Aug 2007 23:38:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] [518/2many] MAINTAINERS - USB SUBSYSTEM
Message-ID: <46bffc81.WriCorMUvDrnRh6I%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f177a2b..ae92220 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4895,6 +4895,11 @@ L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org
 T:	quilt kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/
 S:	Supported
+F:	Documentation/usb/
+F:	drivers/net/usb/
+F:	drivers/usb/
+F:	include/linux/usb.h
+F:	include/linux/usb/
 
 USB UHCI DRIVER
 P:	Alan Stern

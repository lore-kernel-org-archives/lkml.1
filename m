Return-Path: <linux-kernel-owner+w=401wt.eu-S967445AbXHMGjx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967445AbXHMGjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:39:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965755AbXHMGWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:22:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3539 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934790AbXHMGWs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:22:48 -0400
Date: Sun, 12 Aug 2007 23:22:31 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       duncan.sands@free.fr, akpm@linux-foundation.org
Subject: [PATCH] [36/2many] MAINTAINERS - ALCATEL SPEEDTOUCH USB DRIVER
Message-ID: <46bff8a7.leCeVOqSZHPUSGBf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b6827c1..3a586da 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -356,6 +356,8 @@ L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org/SpeedTouch/
 S:	Maintained
+F:	drivers/usb/atm/speedtch.c
+F:	drivers/usb/atm/usbatm.c
 
 ALCHEMY AU1XX0 MMC DRIVER
 S:	Orphan

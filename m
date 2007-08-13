Return-Path: <linux-kernel-owner+w=401wt.eu-S944215AbXHMLbf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944215AbXHMLbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:31:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939250AbXHMGig
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2197 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967132AbXHMGic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:32 -0400
Date: Sun, 12 Aug 2007 23:38:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [495/2many] MAINTAINERS - USB GADGET/PERIPHERAL SUBSYSTEM
Message-ID: <46bffc53.ZMoOdJEytVhhkEOO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index be2b366..ae24def 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4687,6 +4687,8 @@ M:	dbrownell@users.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 W:	http://www.linux-usb.org/gadget
 S:	Maintained
+F:	drivers/usb/gadget/
+F:	include/linux/usb/gadget*
 
 USB HID/HIDBP DRIVERS (USB KEYBOARDS, MICE, REMOTE CONTROLS, ...)
 P:	Jiri Kosina

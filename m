Return-Path: <linux-kernel-owner+w=401wt.eu-S970087AbXHMLjl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970087AbXHMLjl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:39:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967386AbXHMGi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2258 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967322AbXHMGix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:53 -0400
Date: Sun, 12 Aug 2007 23:38:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       gregkh@suse.de, akpm@linux-foundation.org
Subject: [PATCH] [509/2many] MAINTAINERS - USB SERIAL DRIVER
Message-ID: <46bffc6e.wbU+lvyp77SonCSW%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b13366a..728e53f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4814,6 +4814,10 @@ M:	gregkh@suse.de
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Supported
+F:	Documentation/usb/usb-serial.txt
+F:	drivers/usb/serial/generic.c
+F:	drivers/usb/serial/usb-serial.c
+F:	include/linux/usb/serial.h
 
 USB SERIAL BELKIN F5U103 DRIVER
 P:	William Greathouse

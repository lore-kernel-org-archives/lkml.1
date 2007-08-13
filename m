Return-Path: <linux-kernel-owner+w=401wt.eu-S971070AbXHMMV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971070AbXHMMV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763013AbXHMGqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:46:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2554 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939448AbXHMGqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:46:02 -0400
Date: Sun, 12 Aug 2007 23:38:36 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, pberger@brimson.com,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       alborchers@steinerpoint.com, akpm@linux-foundation.org
Subject: [PATCH] [508/2many] MAINTAINERS - USB SERIAL DIGI ACCELEPORT
 DRIVER
Message-ID: <46bffc6c.onXwLh2aL6dL8Vj8%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 93e31ac..b13366a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4799,12 +4799,14 @@ S:	Maintained
 F:	drivers/usb/serial/cyberjack.c
 
 USB SERIAL DIGI ACCELEPORT DRIVER
-P:	Peter Berger and Al Borchers
+P:	Peter Berger
 M:	pberger@brimson.com
+P:	Al Borchers
 M:	alborchers@steinerpoint.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/digi_acceleport.c
 
 USB SERIAL DRIVER
 P:	Greg Kroah-Hartman

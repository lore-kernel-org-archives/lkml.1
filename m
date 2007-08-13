Return-Path: <linux-kernel-owner+w=401wt.eu-S935450AbXHMKRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935450AbXHMKRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967206AbXHMGet
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:49 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1589 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965988AbXHMGen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:43 -0400
Date: Sun, 12 Aug 2007 23:34:29 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nico@cam.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [394/2many] MAINTAINERS - PXA2xx SUPPORT
Message-ID: <46bffb75.pNKePQf1hTn1GZ01%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3889034..6e99107 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3768,6 +3768,11 @@ P:	Nicolas Pitre
 M:	nico@cam.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
+F:	Documentation/spi/pxa2xx
+F:	drivers/pcmcia/pxa2xx*
+F:	drivers/spi/pxa2xx*
+F:	drivers/usb/gadget/pxa2xx*
+F:	sound/soc/pxa/pxa2xx*
 
 PXA MMCI DRIVER
 S:	Orphan

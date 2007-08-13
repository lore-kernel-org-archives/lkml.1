Return-Path: <linux-kernel-owner+w=401wt.eu-S970745AbXHMLk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970745AbXHMLk5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:40:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967322AbXHMGjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:04 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2279 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967413AbXHMGjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:01 -0400
Date: Sun, 12 Aug 2007 23:38:47 -0700
From: joe@perches.com
To: wolfgang@iksw-muees.de, torvalds@linux-foundation.org,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [513/2many] MAINTAINERS - USB AUERSWALD DRIVER
Message-ID: <46bffc77.T04SVFF81waMYSbf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8b4d497..42830d6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4849,6 +4849,7 @@ M:	wolfgang@iksw-muees.de
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/misc/auerswald.c
 
 USB SERIAL EMPEG EMPEG-CAR MARK I/II DRIVER
 P:	Gary Brubaker

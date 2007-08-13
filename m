Return-Path: <linux-kernel-owner+w=401wt.eu-S941223AbXHMLo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941223AbXHMLo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967235AbXHMGjR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2317 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967413AbXHMGjN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:13 -0400
Date: Sun, 12 Aug 2007 23:39:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, stern@rowland.harvard.edu,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [519/2many] MAINTAINERS - USB UHCI DRIVER
Message-ID: <46bffc84.btpFDTlSGMSDsXvu%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ae92220..c670797 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4907,6 +4907,8 @@ M:	stern@rowland.harvard.edu
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/usb/uhci.txt
+F:	drivers/usb/host/uhci*
 
 USB "USBNET" DRIVER FRAMEWORK
 P:	David Brownell

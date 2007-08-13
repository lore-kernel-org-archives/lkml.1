Return-Path: <linux-kernel-owner+w=401wt.eu-S944709AbXHMLq6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944709AbXHMLq6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:46:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967444AbXHMGjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:25 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2344 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965881AbXHMGjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:22 -0400
Date: Sun, 12 Aug 2007 23:39:02 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [520/2many] MAINTAINERS - USB USBNET DRIVER FRAMEWORK
Message-ID: <46bffc86.zUTp+OkLXhZdln2W%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c670797..4dba8ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4916,6 +4916,7 @@ M:	dbrownell@users.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://www.linux-usb.org/usbnet
 S:	Maintained
+F:	drivers/net/usb/usbnet.*
 
 USB W996[87]CF DRIVER
 P:	Luca Risolia

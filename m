Return-Path: <linux-kernel-owner+w=401wt.eu-S965532AbXHMLY1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965532AbXHMLY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:24:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939204AbXHMGiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:17 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2143 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966693AbXHMGiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:10 -0400
Date: Sun, 12 Aug 2007 23:37:58 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, oliver@neukum.name,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [489/2many] MAINTAINERS - USB ACM DRIVER
Message-ID: <46bffc46.O/fR8Jb6biDdSbFC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 51e9dec..228b49f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4635,6 +4635,8 @@ M:	oliver@neukum.name
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	Documentation/usb/acm.txt
+F:	drivers/usb/class/cdc-acm.*
 
 USB BLOCK DRIVER (UB ub)
 P:	Pete Zaitcev

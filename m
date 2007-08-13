Return-Path: <linux-kernel-owner+w=401wt.eu-S969008AbXHMLfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969008AbXHMLfl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939274AbXHMGiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:46 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2226 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939027AbXHMGim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:42 -0400
Date: Sun, 12 Aug 2007 23:38:28 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, petkan@users.sourceforge.net,
       netdev@vger.kernel.org, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [504/2many] MAINTAINERS - USB PEGASUS DRIVER
Message-ID: <46bffc64.Are6NTp/45DX6lxZ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d822865..fc87fa7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4764,6 +4764,7 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	netdev@vger.kernel.org
 W:	http://pegasus2.sourceforge.net/
 S:	Maintained
+F:	drivers/net/usb/pegasus.*
 
 USB PRINTER DRIVER (usblp)
 P:	Pete Zaitcev

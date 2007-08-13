Return-Path: <linux-kernel-owner+w=401wt.eu-S941031AbXHMLis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941031AbXHMLis (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967342AbXHMGi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:56 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2260 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966176AbXHMGiy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:54 -0400
Date: Sun, 12 Aug 2007 23:38:41 -0700
From: joe@perches.com
To: wgreathouse@smva.com, torvalds@linux-foundation.org,
       linux-usb-users@lists.sourceforge.net,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [510/2many] MAINTAINERS - USB SERIAL BELKIN F5U103 DRIVER
Message-ID: <46bffc71.kiMCjrEVxqrpA+yw%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 728e53f..b70f5f8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4825,6 +4825,7 @@ M:	wgreathouse@smva.com
 L:	linux-usb-users@lists.sourceforge.net
 L:	linux-usb-devel@lists.sourceforge.net
 S:	Maintained
+F:	drivers/usb/serial/belkin_sa.*
 
 USB SERIAL CYPRESS M8 DRIVER
 P:	Lonnie Mendez

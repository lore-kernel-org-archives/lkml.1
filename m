Return-Path: <linux-kernel-owner+w=401wt.eu-S932456AbXHMLVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456AbXHMLVb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937893AbXHMGiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2089 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967379AbXHMGhh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:37 -0400
Date: Sun, 12 Aug 2007 23:37:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, tlan-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, chessman@tux.org,
       akpm@linux-foundation.org
Subject: [PATCH] [477/2many] MAINTAINERS - TLAN NETWORK DRIVER
Message-ID: <46bffc1e.SoHjsrOJwnqXMU0X%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 9ae0a45..fda287c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4529,6 +4529,8 @@ M:	chessman@tux.org
 L:	tlan-devel@lists.sourceforge.net
 W:	http://sourceforge.net/projects/tlan/
 S:	Maintained
+F:	Documentation/networking/tlan.txt
+F:	drivers/net/tlan.*
 
 TOKEN-RING NETWORK DRIVER
 P:	Mike Phillips

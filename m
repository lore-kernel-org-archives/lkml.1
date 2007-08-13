Return-Path: <linux-kernel-owner+w=401wt.eu-S942269AbXHMLQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942269AbXHMLQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:16:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966148AbXHMGiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2098 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966176AbXHMGhl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:41 -0400
Date: Sun, 12 Aug 2007 23:37:27 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mid@auk.cx, linux-tr@linuxtr.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [482/2many] MAINTAINERS - TMS380 TOKEN-RING NETWORK
 DRIVER
Message-ID: <46bffc27.qsHLmjILFN1nuBDq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fbd699e..473d852 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4579,6 +4579,8 @@ M:	mid@auk.cx
 L:	linux-tr@linuxtr.net
 W:	http://www.auk.cx/tms380tr/
 S:	Maintained
+F:	Documentation/networking/tms380tr.txt
+F:	drivers/net/tokenring/tms380tr.*
 
 TULIP NETWORK DRIVER
 L:	tulip-users@lists.sourceforge.net

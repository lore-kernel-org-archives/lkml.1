Return-Path: <linux-kernel-owner+w=401wt.eu-S971813AbXHMJkD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971813AbXHMJkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:40:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967082AbXHMGdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1270 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966511AbXHMGdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:00 -0400
Date: Sun, 12 Aug 2007 23:32:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, amitkale@netxen.com,
       akpm@linux-foundation.org
Subject: [PATCH] [342/2many] MAINTAINERS - NETXEN (1/10) GbE SUPPORT
Message-ID: <46bffb0e.H3nQI6dwY+D8gvdP%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index fd59b3d..dbfdb75 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3289,6 +3289,7 @@ M:	amitkale@netxen.com
 L:	netdev@vger.kernel.org
 W:	http://www.netxen.com
 S:	Supported
+F:	drivers/net/netxen/
 
 IPVS
 P:	Wensong Zhang

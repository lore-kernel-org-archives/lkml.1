Return-Path: <linux-kernel-owner+w=401wt.eu-S969064AbXHMIVM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969064AbXHMIVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:21:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966745AbXHMG2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4551 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966354AbXHMG2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:53 -0400
Date: Sun, 12 Aug 2007 23:28:39 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org, klaus.kudielka@ieee.org,
       akpm@linux-foundation.org
Subject: [PATCH] [219/2many] MAINTAINERS - HIGH-SPEED SCC DRIVER FOR AX.25
Message-ID: <46bffa17.GJOIYAQgwSZglXDw%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0202a00..ac6c822 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2090,6 +2090,8 @@ M:	klaus.kudielka@ieee.org
 L:	linux-hams@vger.kernel.org
 W:	http://www.nt.tuwien.ac.at/~kkudielk/Linux/
 S:	Maintained
+F:	drivers/net/hamradio/dmascc.c
+F:	drivers/net/hamradio/scc.c
 
 HIGHPOINT ROCKETRAID 3xxx RAID DRIVER
 P:	HighPoint Linux Team

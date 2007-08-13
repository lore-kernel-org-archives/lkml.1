Return-Path: <linux-kernel-owner+w=401wt.eu-S968148AbXHMHsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968148AbXHMHsz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966412AbXHMG0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:52 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4225 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966397AbXHMG0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:50 -0400
Date: Sun, 12 Aug 2007 23:26:38 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, romieu@fr.zoreil.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [164/2many] MAINTAINERS - DSCC4 DRIVER
Message-ID: <46bff99e.TBmCSnVclKAHlhMB%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 48a734c..3d75c15 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1600,6 +1600,7 @@ P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/wan/dscc4.c
 
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project

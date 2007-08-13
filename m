Return-Path: <linux-kernel-owner+w=401wt.eu-S933569AbXHMKNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933569AbXHMKNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:13:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937824AbXHMGei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1560 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965882AbXHMGed (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:33 -0400
Date: Sun, 12 Aug 2007 23:34:16 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jchapman@katalix.com, akpm@linux-foundation.org
Subject: [PATCH] [387/2many] MAINTAINERS - PPP OVER L2TP
Message-ID: <46bffb68.dsF9nfTAlDpqqXRP%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e8d706b..8d754e2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3698,6 +3698,8 @@ PPP OVER L2TP
 P:	James Chapman
 M:	jchapman@katalix.com
 S:	Maintained
+F:	drivers/net/pppol2tp.c
+F:	include/linux/if_pppol2tp.h
 
 PREEMPTIBLE KERNEL
 P:	Robert Love

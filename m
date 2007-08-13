Return-Path: <linux-kernel-owner+w=401wt.eu-S942756AbXHMHwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942756AbXHMHwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966351AbXHMG1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4283 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966256AbXHMG1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:11 -0400
Date: Sun, 12 Aug 2007 23:26:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, phillip@hellewell.homeip.net,
       mhalcrow@us.ibm.com, linux-kernel@vger.kernel.org,
       ecryptfs-devel@lists.sourceforge.net, akpm@linux-foundation.org
Subject: [PATCH] [170/2many] MAINTAINERS - ECRYPT FILE SYSTEM
Message-ID: <46bff9aa.M4ucYkTT+v9VzCml%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d7d5441..d4325c7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1647,11 +1647,14 @@ F:	include/linux/netfilter_bridge/ebt_*.h
 F:	/net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
-P:	Mike Halcrow, Phillip Hellewell
-M:	mhalcrow@us.ibm.com, phillip@hellewell.homeip.net
+P:	Mike Halcrow
+M:	mhalcrow@us.ibm.com
+P:	Phillip Hellewell
+M:	phillip@hellewell.homeip.net
 L:	ecryptfs-devel@lists.sourceforge.net
 W:	http://ecryptfs.sourceforge.net/
 S:	Supported
+F:	fs/ecryptfs/
 
 EDAC-CORE
 P:	Doug Thompson

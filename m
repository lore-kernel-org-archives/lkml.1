Return-Path: <linux-kernel-owner+w=401wt.eu-S968177AbXHMHv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968177AbXHMHv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:51:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966363AbXHMG1M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4278 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966347AbXHMG1K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:10 -0400
Date: Sun, 12 Aug 2007 23:26:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ebtables-user@lists.sourceforge.net,
       ebtables-devel@lists.sourceforge.net, bart.de.schuymer@pandora.be,
       akpm@linux-foundation.org
Subject: [PATCH] [169/2many] MAINTAINERS - EBTABLES
Message-ID: <46bff9a8.KGSkQcMtpwXzwKTD%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 45ce2d4..d7d5441 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1643,6 +1643,8 @@ L:	ebtables-user@lists.sourceforge.net
 L:	ebtables-devel@lists.sourceforge.net
 W:	http://ebtables.sourceforge.net/
 S:	Maintained
+F:	include/linux/netfilter_bridge/ebt_*.h
+F:	/net/bridge/netfilter/ebt*.c
 
 ECRYPT FILE SYSTEM
 P:	Mike Halcrow, Phillip Hellewell

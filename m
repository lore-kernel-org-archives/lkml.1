Return-Path: <linux-kernel-owner+w=401wt.eu-S1763991AbXHMKUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763991AbXHMKUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763935AbXHMGdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:18 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1287 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966965AbXHMGdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:06 -0400
Date: Sun, 12 Aug 2007 23:32:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netfilter-devel@lists.netfilter.org,
       linux-kernel@vger.kernel.org, kaber@trash.net, coreteam@netfilter.org,
       akpm@linux-foundation.org
Subject: [PATCH] [334/2many] MAINTAINERS - NETFILTER/IPTABLES/IPCHAINS
Message-ID: <46bffb00.MIU7+dJ2jzwTaehX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7e3b438..bc571b8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3200,6 +3200,12 @@ L:	coreteam@netfilter.org
 W:	http://www.netfilter.org/
 W:	http://www.iptables.org/
 S:	Supported
+F:	include/linux/netfilter*
+F:	include/linux/netfilter/
+F:	include/net/netfilter/
+F:	net/*/netfilter.c
+F:	net/*/netfilter/
+F:	net/netfilter/
 
 NETLABEL
 P:	Paul Moore

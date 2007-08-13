Return-Path: <linux-kernel-owner+w=401wt.eu-S968611AbXHMJiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968611AbXHMJiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967062AbXHMGcz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:55 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1252 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967057AbXHMGcx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:53 -0400
Date: Sun, 12 Aug 2007 23:32:41 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [339/2many] MAINTAINERS - NETWORKING [GENERAL]
Message-ID: <46bffb09.E015OcwUNjut8WPv%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b67dda3..1ddb242 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3251,6 +3251,8 @@ M:	netdev@vger.kernel.org
 L:	netdev@vger.kernel.org
 W:	http://linux-net.osdl.org/
 S:	Maintained
+F:	net/
+F:	include/net/
 
 NETWORKING [IPv4/IPv6]
 P:	David S. Miller

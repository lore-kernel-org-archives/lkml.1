Return-Path: <linux-kernel-owner+w=401wt.eu-S941902AbXHMH2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941902AbXHMH2A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966067AbXHMGZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:41 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4016 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966212AbXHMGZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:37 -0400
Date: Sun, 12 Aug 2007 23:25:19 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@wantstofly.org,
       akpm@linux-foundation.org
Subject: [PATCH] [125/2many] MAINTAINERS - CIRRUS LOGIC EP93XX ETHERNET
 DRIVER
Message-ID: <46bff94f.XqQlvpgFqhyYcyg6%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e5853e8..8b28143 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1216,6 +1216,7 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/arm/ep93xx_eth.c
 
 CIRRUS LOGIC GENERIC FBDEV DRIVER
 P:	Jeff Garzik

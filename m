Return-Path: <linux-kernel-owner+w=401wt.eu-S944826AbXHMLv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944826AbXHMLv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967459AbXHMGjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2376 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967455AbXHMGjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:33 -0400
Date: Sun, 12 Aug 2007 23:39:20 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, romieu@fr.zoreil.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [530/2many] MAINTAINERS - VIA VELOCITY NETWORK DRIVER
Message-ID: <46bffc98.lHe88PoL/SR8qHEB%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 392d697..be3d826 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5002,6 +5002,7 @@ P:	Francois Romieu
 M:	romieu@fr.zoreil.com
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	/drivers/net/via-velocity.*
 
 UCLINUX (AND M68KNOMMU)
 P:	Greg Ungerer

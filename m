Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXHMKPQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXHMKPQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:15:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967146AbXHMGen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1578 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937893AbXHMGej (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:39 -0400
Date: Sun, 12 Aug 2007 23:34:23 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       mokuno@sm.sony.co.jp, linux-kernel@vger.kernel.org,
       cbe-oss-dev@ozlabs.org, akpm@linux-foundation.org
Subject: [PATCH] [391/2many] MAINTAINERS - PS3 NETWORK SUPPORT
Message-ID: <46bffb6f.CLgzLs+J4a/+58Iy%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 19f2a5f..4fe48a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3738,6 +3738,7 @@ M:	mokuno@sm.sony.co.jp
 L:	netdev@vger.kernel.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	drivers/net/ps3_gelic_net.*
 
 PS3 PLATFORM SUPPORT
 P:	Geoff Levand

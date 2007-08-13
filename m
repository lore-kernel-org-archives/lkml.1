Return-Path: <linux-kernel-owner+w=401wt.eu-S970386AbXHMIok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970386AbXHMIok (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966804AbXHMGaQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:16 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4743 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966550AbXHMGaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:07 -0400
Date: Sun, 12 Aug 2007 23:29:51 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@wantstofly.org,
       akpm@linux-foundation.org
Subject: [PATCH] [255/2many] MAINTAINERS - INTEL IXP2000 ETHERNET DRIVER
Message-ID: <46bffa5f.Ap1G6z9cjrAITLGp%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index dccbaba..d5e1d3f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2423,6 +2423,7 @@ P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
 L:	netdev@vger.kernel.org
 S:	Maintained
+F:	drivers/net/ixp2000/
 
 INTEL PRO/100 ETHERNET SUPPORT
 P:	John Ronciak

Return-Path: <linux-kernel-owner+w=401wt.eu-S942494AbXHMMLH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942494AbXHMMLH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:11:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967423AbXHMGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2504 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763405AbXHMGkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:16 -0400
Date: Sun, 12 Aug 2007 23:40:00 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org, jreuter@yaina.de, akpm@linux-foundation.org
Subject: [PATCH] [551/2many] MAINTAINERS - Z8530 DRIVER FOR AX.25
Message-ID: <46bffcc0.kagzT61H3VnCgrxZ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 351e6bf..cd5856d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5216,6 +5216,9 @@ W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	Documentation/networking/z8530drv.txt
+F:	drivers/net/*scc.c
+F:	drivers/net/hamradio/z8530.h
 
 ZD1211RW WIRELESS DRIVER
 P:	Daniel Drake

Return-Path: <linux-kernel-owner+w=401wt.eu-S971695AbXHMJTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971695AbXHMJTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966907AbXHMGcL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1107 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967013AbXHMGcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:07 -0400
Date: Sun, 12 Aug 2007 23:31:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, netdev@vger.kernel.org,
       mlachwani@mvista.com, linux-kernel@vger.kernel.org, dale@farnsworth.org,
       akpm@linux-foundation.org
Subject: [PATCH] [310/2many] MAINTAINERS - MARVELL MV643XX ETHERNET DRIVER
Message-ID: <46bffad0.gGobH3kJcTurAxTC%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 68b22f3..ce9418a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2990,6 +2990,8 @@ P:	Manish Lachwani
 M:	mlachwani@mvista.com
 L:	netdev@vger.kernel.org
 S:	Odd Fixes for 2.4; Maintained for 2.6.
+F:	drivers/net/mv643xx_eth.*
+F:	include/linux/mv643xx.h
 
 MATROX FRAMEBUFFER DRIVER
 P:	Petr Vandrovec

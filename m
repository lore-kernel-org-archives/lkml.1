Return-Path: <linux-kernel-owner+w=401wt.eu-S943038AbXHMK4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943038AbXHMK4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:56:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967355AbXHMGgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:36:51 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1944 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967368AbXHMGgs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:36:48 -0400
Date: Sun, 12 Aug 2007 23:36:32 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, drzeus-sdhci@drzeus.cx,
       akpm@linux-foundation.org
Subject: [PATCH] [454/2many] MAINTAINERS - SECURE DIGITAL HOST CONTROLLER
 INTERFACE DRIVER
Message-ID: <46bffbf0.MqyoK1xPnxXShBFr%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4af5d59..a40c7ed 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4341,6 +4341,7 @@ M:	drzeus-sdhci@drzeus.cx
 L:	sdhci-devel@list.drzeus.cx
 W:	http://mmc.drzeus.cx/wiki/Linux/Drivers/sdhci
 S:	Maintained
+F:	drivers/mmc/host/sdhci.*
 
 SKGE, SKY2 10/100/1000 GIGABIT ETHERNET DRIVERS
 P:	Stephen Hemminger

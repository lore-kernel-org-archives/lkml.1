Return-Path: <linux-kernel-owner+w=401wt.eu-S969647AbXHMJ1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969647AbXHMJ1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966239AbXHMGc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:29 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1168 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967023AbXHMGcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:23 -0400
Date: Sun, 12 Aug 2007 23:32:10 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ppisa@pikron.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [322/2many] MAINTAINERS - MOTOROLA IMX MMC/SD HOST
 CONTROLLER INTERFACE DRIVER
Message-ID: <46bffaea.9eZfjjbX0RTIxLG/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index aeb86e6..ddff41d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3099,6 +3099,7 @@ M:	ppisa@pikron.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://mmc.drzeus.cx/wiki/Controllers/Freescale/SDHC
 S:	Maintained
+F:	drivers/mmc/host/imxmmc.*
 
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini

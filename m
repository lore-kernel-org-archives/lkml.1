Return-Path: <linux-kernel-owner+w=401wt.eu-S941237AbXHMIGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941237AbXHMIGO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966366AbXHMG2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:08 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4421 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966604AbXHMG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:06 -0400
Date: Sun, 12 Aug 2007 23:27:48 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxppc-embedded@ozlabs.org,
       linux-usb-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       leoli@freescale.com, akpm@linux-foundation.org
Subject: [PATCH] [194/2many] MAINTAINERS - FREESCALE HIGHSPEED USB DEVICE
 DRIVER
Message-ID: <46bff9e4.zwo/ub/ZnK6PrXO2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2ef0ec4..944316a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1868,6 +1868,7 @@ M:	leoli@freescale.com
 L:	linux-usb-devel@lists.sourceforge.net
 L:	linuxppc-embedded@ozlabs.org
 S:	Maintained
+F:	drivers/usb/gadget/fsl_usb2_udc.c
 
 FREESCALE QUICC ENGINE UCC ETHERNET DRIVER
 P:	Li Yang

Return-Path: <linux-kernel-owner+w=401wt.eu-S935152AbXHMKRA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935152AbXHMKRA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:17:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965882AbXHMGer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1593 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967057AbXHMGeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:44 -0400
Date: Sun, 12 Aug 2007 23:34:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, geoffrey.levand@am.sony.com,
       cbe-oss-dev@ozlabs.org, akpm@linux-foundation.org
Subject: [PATCH] [392/2many] MAINTAINERS - PS3 PLATFORM SUPPORT
Message-ID: <46bffb71.JWcVvIR5pg3biTEh%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4fe48a0..62b6ede 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3746,6 +3746,12 @@ M:	geoffrey.levand@am.sony.com
 L:	linuxppc-dev@ozlabs.org
 L:	cbe-oss-dev@ozlabs.org
 S:	Supported
+F:	arch/powerpc/boot/ps3*
+F:	arch/powerpc/platforms/ps3/
+F:	drivers/*/ps3*
+F:	drivers/ps3/
+F:	drivers/usb/host/*ps3.c
+F:	include/asm-powerpc/ps3*
 
 PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely

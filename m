Return-Path: <linux-kernel-owner+w=401wt.eu-S1760186AbXHMKbL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186AbXHMKbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:31:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966466AbXHMGfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1751 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966001AbXHMGfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:39 -0400
Date: Sun, 12 Aug 2007 23:35:25 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jim.cromie@gmail.com, akpm@linux-foundation.org
Subject: [PATCH] [423/2many] MAINTAINERS - SCx200 CPU SUPPORT
Message-ID: <46bffbad.OdqDsCniSJ5LREk/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a1e3a1a..c4f7cff 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4025,6 +4025,12 @@ SCx200 CPU SUPPORT
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Odd Fixes
+F:	Documentation/i2c/busses/scx200_acb
+F:	arch/i386/kernel/scx200.c
+F:	drivers/char/watchdog/scx200_wdt.c
+F:	drivers/i2c/busses/scx200*
+F:	drivers/mtd/maps/scx200_docflash.c
+F:	include/linux/scx200.h
 
 SCx200 GPIO DRIVER
 P:	Jim Cromie

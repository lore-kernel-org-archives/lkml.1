Return-Path: <linux-kernel-owner+w=401wt.eu-S967845AbXHMGnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967845AbXHMGnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965832AbXHMGXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3570 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965813AbXHMGXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:00 -0400
Date: Sun, 12 Aug 2007 23:22:46 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-laptop@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [44/2many] MAINTAINERS - APM DRIVER
Message-ID: <46bff8b6.XgYxpWqOSD9Itfw6%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 016f342..da9bc6d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -428,6 +428,9 @@ M:	sfr@canb.auug.org.au
 L:	linux-laptop@vger.kernel.org
 W:	http://www.canb.auug.org.au/~sfr/
 S:	Supported
+F:	arch/i386/boot/apm.c
+F:	arch/i386/kernel/apm.c
+F:	include/linux/apm_bios.h
 
 APPLE SMC DRIVER
 P:	Nicolas Boichat

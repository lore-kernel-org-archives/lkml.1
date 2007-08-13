Return-Path: <linux-kernel-owner+w=401wt.eu-S939432AbXHMK2G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939432AbXHMK2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:28:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967283AbXHMGff
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:35 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1707 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967254AbXHMGfZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:25 -0400
Date: Sun, 12 Aug 2007 23:35:11 -0700
From: joe@perches.com
To: zwane@arm.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [416/2many] MAINTAINERS - SC1200 WDT DRIVER
Message-ID: <46bffb9f.WO7bxm3tfxmHn6ha%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 20b6f25..e7524a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3964,6 +3964,7 @@ SC1200 WDT DRIVER
 P:	Zwane Mwaikambo
 M:	zwane@arm.linux.org.uk
 S:	Maintained
+F:	drivers/char/watchdog/sc1200wdt.c
 
 SCHEDULER
 P:	Ingo Molnar

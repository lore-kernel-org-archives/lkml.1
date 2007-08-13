Return-Path: <linux-kernel-owner+w=401wt.eu-S936619AbXHMG65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936619AbXHMG65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966052AbXHMGYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:01 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3737 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966039AbXHMGYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:00 -0400
Date: Sun, 12 Aug 2007 23:23:47 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nicolas.ferre@rfo.atmel.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [76/2many] MAINTAINERS - ATMEL AT91 MCI DRIVER
Message-ID: <46bff8f3.0o2TEk1SQWqs1fUO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a393f71..3568f85 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -770,6 +770,7 @@ L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 W:	http://www.atmel.com/products/AT91/
 W:	http://www.at91.com/
 S:	Maintained
+F:	drivers/mmc/host/at91_mci.c
 
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen

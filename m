Return-Path: <linux-kernel-owner+w=401wt.eu-S940034AbXHMHIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940034AbXHMHIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965298AbXHMGYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3811 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966097AbXHMGYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:25 -0400
Date: Sun, 12 Aug 2007 23:24:12 -0700
From: joe@perches.com
To: vapier.adi@gmail.com, torvalds@linux-foundation.org,
       michael.frysinger@analog.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [89/2many] MAINTAINERS - BLACKFIN WATCHDOG DRIVER
Message-ID: <46bff90c.u9UinA0YZjbCoZJ6%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 641791f..589e469 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -912,6 +912,7 @@ M:	vapier.adi@gmail.com
 L:	uclinux-dist-devel@blackfin.uclinux.org (subscribers-only)
 W:	http://blackfin.uclinux.org
 S:	Supported
+F:	drivers/char/watchdog/bfin_wdt.c
 
 BAYCOM/HDLCDRV DRIVERS FOR AX.25
 P:	Thomas Sailer

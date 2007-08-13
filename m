Return-Path: <linux-kernel-owner+w=401wt.eu-S965293AbXHMLGl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965293AbXHMLGl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:06:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967357AbXHMGhd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2036 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967321AbXHMGhT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:19 -0400
Date: Sun, 12 Aug 2007 23:37:05 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, oakad@yahoo.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [471/2many] MAINTAINERS - TI FLASH MEDIA INTERFACE DRIVER
Message-ID: <46bffc11.YSm4aXQ1lZ6AaDyf%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index e45a848..af16a17 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4471,9 +4471,11 @@ S:	Maintained
 F:	net/ipv4/tcp_lp.c
 
 TI FLASH MEDIA INTERFACE DRIVER
-P:      Alex Dubov
-M:      oakad@yahoo.com
-S:      Maintained
+P:	Alex Dubov
+M:	oakad@yahoo.com
+S:	Maintained
+F:	drivers/misc/tifm*
+F:	drivers/mmc/host/tifm_sd.c
 
 TI OMAP MMC INTERFACE DRIVER
 P:	Carlos Aguiar, Anderson Briglia and Syed Khasim

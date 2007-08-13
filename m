Return-Path: <linux-kernel-owner+w=401wt.eu-S942249AbXHMHjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942249AbXHMHjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965948AbXHMG0V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:21 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4133 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966057AbXHMG0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:15 -0400
Date: Sun, 12 Aug 2007 23:25:57 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-hams@vger.kernel.org, jreuter@yaina.de, akpm@linux-foundation.org
Subject: [PATCH] [145/2many] MAINTAINERS - DAMA SLAVE for AX.25
Message-ID: <46bff975.0bZ+hK8DH0JZsKvO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index f7e928d..96a7da8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1397,6 +1397,13 @@ W:	http://yaina.de/jreuter/
 W:	http://www.qsl.net/dl1bke/
 L:	linux-hams@vger.kernel.org
 S:	Maintained
+F:	net/ax25/af_ax25.c
+F:	net/ax25/ax25_dev.c
+F:	net/ax25/ax25_ds_*
+F:	net/ax25/ax25_in.c
+F:	net/ax25/ax25_out.c
+F:	net/ax25/ax25_timer.c
+F:	net/ax25/sysctl_net_ax25.c
 
 DC395x SCSI driver
 P:	Oliver Neukum

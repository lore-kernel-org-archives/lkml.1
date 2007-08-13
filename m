Return-Path: <linux-kernel-owner+w=401wt.eu-S966542AbXHMIPK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966542AbXHMIPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:15:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966683AbXHMG2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:36 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4502 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966677AbXHMG2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:35 -0400
Date: Sun, 12 Aug 2007 23:28:14 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org, khc@pm.waw.pl,
       akpm@linux-foundation.org
Subject: [PATCH] [207/2many] MAINTAINERS - GENERIC HDLC DRIVER, N2, C101,
 PCI200SYN and WANXL DRIVERS
Message-ID: <46bff9fe.9xNl+safkaL7/d/Z%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index bdfbda0..d8063ee 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1975,6 +1975,14 @@ P:	Krzysztof Halasa
 M:	khc@pm.waw.pl
 W:	http://www.kernel.org/pub/linux/utils/net/hdlc/
 S:	Maintained
+F:	Documentation/networking/generic-hdlc.txt
+F:	drivers/net/wan/c101.c
+F:	drivers/net/wan/hd6457x.c
+F:	drivers/net/wan/hdlc*
+F:	drivers/net/wan/n2.c
+F:	drivers/net/wan/pc300too.c
+F:	drivers/net/wan/pci200syn.c
+F:	drivers/net/wan/wanxl*
 
 GFS2 FILE SYSTEM
 P:	Steven Whitehouse

Return-Path: <linux-kernel-owner+w=401wt.eu-S970491AbXHMIqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970491AbXHMIqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966858AbXHMGaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:22 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4771 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966602AbXHMGaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:19 -0400
Date: Sun, 12 Aug 2007 23:30:06 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, ralf@linux-mips.org,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [261/2many] MAINTAINERS - IOC3 DRIVER
Message-ID: <46bffa6e.aluJMNuvp11tc2XU%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6263958..207331c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2501,6 +2501,8 @@ P:	Ralf Baechle
 M:	ralf@linux-mips.org
 L:	linux-mips@linux-mips.org
 S:	Maintained
+F:	drivers/net/ioc3-eth.c
+F:	drivers/serial/ioc3_serial.c
 
 IP MASQUERADING:
 P:	Juanjo Ciarlante

Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXHMKHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXHMKHE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967140AbXHMGeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:34:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1515 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967179AbXHMGeP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:34:15 -0400
Date: Sun, 12 Aug 2007 23:33:54 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, joern@wohnheim.fh-wedel.de,
       akpm@linux-foundation.org
Subject: [PATCH] [377/2many] MAINTAINERS - PHRAM MTD DRIVER
Message-ID: <46bffb52.iWg07DXAXPcVIyVe%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index b81c8bc..e165480 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3621,6 +3621,7 @@ P:	Jörn Engel
 M:	joern@wh.fh-wedel.de
 L:	linux-mtd@lists.infradead.org
 S:	Maintained
+F:	drivers/mtd/devices/phram.c
 
 PKTCDVD DRIVER
 P:	Peter Osterlund

Return-Path: <linux-kernel-owner+w=401wt.eu-S941651AbXHMHq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941651AbXHMHq0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966275AbXHMG0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4207 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966372AbXHMG0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:43 -0400
Date: Sun, 12 Aug 2007 23:26:26 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       akpm@linux-foundation.org
Subject: [PATCH] [158/2many] MAINTAINERS - DMA GENERIC OFFLOAD ENGINE
 SUBSYSTEM
Message-ID: <46bff992.LnPkEgfnfLCX18hX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 60bda8d..70e5070 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1544,6 +1544,9 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/
+F:	include/linux/dma*
+F:	kernel/dma.c
 
 DME1737 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger

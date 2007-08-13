Return-Path: <linux-kernel-owner+w=401wt.eu-S970013AbXHMIlF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970013AbXHMIlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:41:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966185AbXHMGaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:05 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4728 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966850AbXHMG37 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:59 -0400
Date: Sun, 12 Aug 2007 23:29:45 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, akpm@linux-foundation.org
Subject: [PATCH] [253/2many] MAINTAINERS - INTEL IOP-ADMA DMA DRIVER
Message-ID: <46bffa59.ydZjAhAKpNNtyksl%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 773dd76..da059b9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2410,6 +2410,7 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-kernel@vger.kernel.org
 S:	Supported
+F:	drivers/dma/ioatdma*
 
 INTEL IXP4XX RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena

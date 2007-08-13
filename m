Return-Path: <linux-kernel-owner+w=401wt.eu-S968239AbXHMGwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968239AbXHMGwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 02:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965906AbXHMGXc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:23:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3657 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965895AbXHMGXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:23:30 -0400
Date: Sun, 12 Aug 2007 23:23:16 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dan.j.williams@intel.com, akpm@linux-foundation.org
Subject: [PATCH] [60/2many] MAINTAINERS - ARM/INTEL IOP33X ARM
 ARCHITECTURE
Message-ID: <46bff8d4.sLR4H8q4gzkdAzcT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 91e32ed..dd0806c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -555,6 +555,8 @@ P:	Dan Williams
 M:	dan.j.williams@intel.com
 L:	linux-arm-kernel@lists.arm.linux.org.uk (subscribers-only)
 S:	Supported
+F:	arch/arm/mach-iop33x/
+F:	include/asm-arm/plat-iop/
 
 ARM/INTEL IOP13XX ARM ARCHITECTURE
 P:	Lennert Buytenhek

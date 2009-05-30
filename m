Return-Path: <linux-kernel-owner+w=401wt.eu-S1760023AbZE3Mpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760023AbZE3Mpe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 08:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756594AbZE3Mp0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 08:45:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:55231 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666AbZE3Mp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 08:45:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,275,1241420400"; 
   d="scan'208";a="148691679"
Date: Sat, 30 May 2009 20:45:20 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trivial Patch Monkey <trivial@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: fix memory map comment
Message-ID: <20090530124520.GA8663@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
diff --git a/arch/x86/include/asm/page_64_types.h b/arch/x86/include/asm/page_64_types.h
index d38c91b..786306c 100644
--- a/arch/x86/include/asm/page_64_types.h
+++ b/arch/x86/include/asm/page_64_types.h
@@ -47,7 +47,7 @@
 #define __START_KERNEL		(__START_KERNEL_map + __PHYSICAL_START)
 #define __START_KERNEL_map	_AC(0xffffffff80000000, UL)
 
-/* See Documentation/x86_64/mm.txt for a description of the memory map. */
+/* See Documentation/x86/x86_64/mm.txt for a description of the memory map. */
 #define __PHYSICAL_MASK_SHIFT	46
 #define __VIRTUAL_MASK_SHIFT	48
 

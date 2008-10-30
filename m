Return-Path: <linux-kernel-owner+w=401wt.eu-S1753720AbYJ3DmS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753720AbYJ3DmS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 23:42:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbYJ3DmD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 23:42:03 -0400
Received: from mga05.intel.com ([192.55.52.89]:29058 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752308AbYJ3DmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 23:42:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,511,1220252400"; 
   d="scan'208";a="633216147"
Date: Thu, 30 Oct 2008 11:41:46 +0800
From: Kent Liu <kent.liu@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au, austin.zhang@intel.com,
       austin_zhang@linux.intel.com
Subject: [PATCH] crc32c-intel: Update copyright head
Message-ID: <20081030034146.GA9027@wliu-linux.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original copyright head for crc32c-intel.c is incorrect. Please merge
the patch to update it.

Signed-Off-By: Kent Liu <kent.liu@intel.com>
---
diff --git a/arch/x86/crypto/crc32c-intel.c b/arch/x86/crypto/crc32c-intel.c
index 070afc5..a2c539c 100644
--- a/arch/x86/crypto/crc32c-intel.c
+++ b/arch/x86/crypto/crc32c-intel.c
@@ -6,13 +6,22 @@
  * Intel(R) 64 and IA-32 Architectures Software Developer's Manual
  * Volume 2A: Instruction Set Reference, A-M
  *
- * Copyright (c) 2008 Austin Zhang <austin_zhang@linux.intel.com>
- * Copyright (c) 2008 Kent Liu <kent.liu@intel.com>
+ * Copyright (C) 2008 Intel Corporation
+ * Authors: Austin Zhang <austin_zhang@linux.intel.com>
+ *          Kent Liu <kent.liu@intel.com>
  *
  * This program is free software; you can redistribute it and/or modify it
- * under the terms of the GNU General Public License as published by the Free
- * Software Foundation; either version 2 of the License, or (at your option)
- * any later version.
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin St - Fifth Floor, Boston, MA 02110-1301 USA.
  *
  */
 #include <linux/init.h>
@@ -194,4 +203,3 @@ MODULE_LICENSE("GPL");
 
 MODULE_ALIAS("crc32c");
 MODULE_ALIAS("crc32c-intel");
-

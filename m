Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZLBEjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZLBEjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 23:39:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755315AbZLBEha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 23:37:30 -0500
Received: from mga03.intel.com ([143.182.124.21]:35897 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755206AbZLBEh3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 23:37:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="scan'208";a="217764890"
Message-Id: <20091202043043.715851393@intel.com>
User-Agent: quilt/0.48-1
Date: Wed, 02 Dec 2009 11:12:32 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
TO: Andi Kleen <andi@firstfloor.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
CC: Nick Piggin <npiggin@suse.de>
CC: <linux-mm@kvack.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 01/24] page-types: add standard GPL license head
References: <20091202031231.735876003@intel.com>
Content-Disposition: inline; filename=page-types-gpl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-11-07 19:28:51.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-11-08 22:04:04.000000000 +0800
@@ -1,11 +1,22 @@
 /*
  * page-types: Tool for querying page flags
  *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the Free
+ * Software Foundation; version 2.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should find a copy of v2 of the GNU General Public License somewhere on
+ * your Linux system; if not, write to the Free Software Foundation, Inc., 59
+ * Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
  * Copyright (C) 2009 Intel corporation
  *
  * Authors: Wu Fengguang <fengguang.wu@intel.com>
- *
- * Released under the General Public License (GPL).
  */
 
 #define _LARGEFILE64_SOURCE



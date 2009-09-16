Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbZIPKaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbZIPKaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757566AbZIPKas
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 06:30:48 -0400
Received: from mga14.intel.com ([143.182.124.37]:4142 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757164AbZIPK3C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 06:29:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,397,1249282800"; 
   d="scan'208";a="188224415"
Message-Id: <20090916100657.254133183@intel.com>
References: <20090916100119.275066569@intel.com>
User-Agent: quilt/0.46-1
Date: Wed, 16 Sep 2009 18:01:22 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/8] page-types: add GPL note
Content-Disposition: inline; filename=page-types-gpl.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 Documentation/vm/page-types.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- linux-mm.orig/Documentation/vm/page-types.c	2009-09-16 17:16:26.000000000 +0800
+++ linux-mm/Documentation/vm/page-types.c	2009-09-16 17:24:22.000000000 +0800
@@ -2,7 +2,10 @@
  * page-types: Tool for querying page flags
  *
  * Copyright (C) 2009 Intel corporation
- * Copyright (C) 2009 Wu Fengguang <fengguang.wu@intel.com>
+ *
+ * Authors: Wu Fengguang <fengguang.wu@intel.com>
+ *
+ * Released under the General Public License (GPL).
  */
 
 #define _LARGEFILE64_SOURCE

-- 


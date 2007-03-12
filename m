Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXCLJ7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXCLJ7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 05:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965461AbXCLJ7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 05:59:19 -0400
Received: from mga06.intel.com ([134.134.136.21]:47709 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965462AbXCLJ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 05:59:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,274,1170662400"; 
   d="scan'208"; a="207908986:sNHT21081200"
Message-Id: <20070312095912.743760000@linux.intel.com>
References: <20070312093128.577087000@linux.intel.com>
User-Agent: quilt/0.45-1
Date: Mon, 12 Mar 2007 02:59:32 -0700
From: Valerie Henson <val_henson@linux.intel.com>
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Valerie Henson <val_henson@linux.intel.com>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 4/4] [TULIP]  Rev tulip version
Content-Disposition: inline; filename=tulip-rev-version
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rev tulip version... things have changed since 2002!

Signed-off-by: Valerie Henson <val_henson@linux.intel.com>
Cc: Jeff Garzik <jeff@garzik.org>

---
 drivers/net/tulip/tulip_core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- tulip-2.6-mm-linux.orig/drivers/net/tulip/tulip_core.c
+++ tulip-2.6-mm-linux/drivers/net/tulip/tulip_core.c
@@ -17,11 +17,11 @@
 
 #define DRV_NAME	"tulip"
 #ifdef CONFIG_TULIP_NAPI
-#define DRV_VERSION    "1.1.14-NAPI" /* Keep at least for test */
+#define DRV_VERSION    "1.1.15-NAPI" /* Keep at least for test */
 #else
-#define DRV_VERSION	"1.1.14"
+#define DRV_VERSION	"1.1.15"
 #endif
-#define DRV_RELDATE	"May 11, 2002"
+#define DRV_RELDATE	"Feb 27, 2007"
 
 
 #include <linux/module.h>

--

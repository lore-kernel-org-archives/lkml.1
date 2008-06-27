Return-Path: <linux-kernel-owner+w=401wt.eu-S1762479AbYF0SFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762479AbYF0SFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 14:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761963AbYF0SBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 14:01:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:59599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761921AbYF0SB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 14:01:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,716,1204531200"; 
   d="scan'208";a="300315897"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [NET-NEXT PATCH 12/18] igb: Increment driver version
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       e1000-devel@lists.sourceforge.net
Date: Fri, 27 Jun 2008 11:01:20 -0700
Message-ID: <20080627180117.22428.38900.stgit@localhost.localdomain>
In-Reply-To: <20080627175921.22428.52767.stgit@localhost.localdomain>
References: <20080627175921.22428.52767.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jun 2008 18:01:21.0105 (UTC) FILETIME=[CE253410:01C8D87F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Auke Kok <auke-jan.h.kok@intel.com>

Signed-off-by: Auke Kok <auke-jan.h.kok@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/igb/igb_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/igb/igb_main.c b/drivers/net/igb/igb_main.c
index 27fca76..b6d7aa9 100644
--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -46,7 +46,7 @@
 #endif
 #include "igb.h"
 
-#define DRV_VERSION "1.0.8-k2"
+#define DRV_VERSION "1.2.45-k2"
 char igb_driver_name[] = "igb";
 char igb_driver_version[] = DRV_VERSION;
 static const char igb_driver_string[] =


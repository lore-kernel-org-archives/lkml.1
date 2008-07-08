Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbYGHWJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbYGHWJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 18:09:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752879AbYGHWJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 18:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:50330 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606AbYGHWJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 18:09:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,326,1212390000"; 
   d="scan'208";a="586798311"
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [RESEND NET-NEXT PATCH 12/20] igb: Increment driver version
To: jeff@garzik.org, davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Auke Kok <auke-jan.h.kok@intel.com>,
       Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Tue, 08 Jul 2008 15:09:37 -0700
Message-ID: <20080708220834.1518.62899.stgit@localhost.localdomain>
In-Reply-To: <20080708220046.1518.88457.stgit@localhost.localdomain>
References: <20080708220046.1518.88457.stgit@localhost.localdomain>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2008 22:09:37.0598 (UTC) FILETIME=[4FB0E5E0:01C8E147]
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
index ae329c0..1436326 100644
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


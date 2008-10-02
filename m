Return-Path: <linux-kernel-owner+w=401wt.eu-S1756183AbYJBXfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbYJBXfp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 19:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755879AbYJBXd7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 19:33:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:9487 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbYJBXd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 19:33:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,353,1220252400"; 
   d="scan'208";a="386973970"
From: Jesse Brandeburg <jesse.brandeburg@intel.com>
Subject: [PATCH 2.6.27-rc8 6/6] e1000e: update version from k4 to k6
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, tglx@linutronix.de,
       arjan@linux.intel.com, airlied@gmail.com, davem@davemloft.net,
       jeff@garzik.org, Jesse Brandeburg <jesse.brandeburg@intel.com>
Date: Thu, 02 Oct 2008 16:33:45 -0700
Message-ID: <20081002233345.12556.64335.stgit@jbrandeb-bw.jf.intel.com>
In-Reply-To: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
References: <20081002233314.12556.49143.stgit@jbrandeb-bw.jf.intel.com>
User-Agent: StGIT/0.14.3.163.g06f9.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Oct 2008 23:33:45.0530 (UTC) FILETIME=[5004B1A0:01C924E7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---

 drivers/net/e1000e/netdev.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/e1000e/netdev.c b/drivers/net/e1000e/netdev.c
index 01e9558..b81c423 100644
--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -47,7 +47,7 @@
 
 #include "e1000.h"
 
-#define DRV_VERSION "0.3.3.3-k4"
+#define DRV_VERSION "0.3.3.3-k6"
 char e1000e_driver_name[] = "e1000e";
 const char e1000e_driver_version[] = DRV_VERSION;
 


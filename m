Return-Path: <linux-kernel-owner+w=401wt.eu-S1759747AbYJMRPq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759747AbYJMRPq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 13:15:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbYJMRPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 13:15:31 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:16459 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755562AbYJMRPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 13:15:30 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 1/2 2.6.28] cxgb3 - update driver version
To: jeff@garzik.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Mon, 13 Oct 2008 10:15:25 -0700
Message-ID: <20081013171525.23321.84016.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

Add a field to the driver versioning info.
Update version to 1.1.0.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 29db711..ed16907 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -35,7 +35,7 @@
 #define DRV_DESC "Chelsio T3 Network Driver"
 #define DRV_NAME "cxgb3"
 /* Driver version */
-#define DRV_VERSION "1.0-ko"
+#define DRV_VERSION "1.1.0-ko"
 
 /* Firmware version */
 #define FW_VERSION_MAJOR 7


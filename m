Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbXDZUWP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbXDZUWP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 16:22:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755014AbXDZUVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 16:21:31 -0400
Received: from rrcs-71-42-183-126.sw.biz.rr.com ([71.42.183.126]:52561 "EHLO
	smtp.opengridcomputing.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755007AbXDZUV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 16:21:27 -0400
From: Steve Wise <swise@opengridcomputing.com>
Subject: [PATCH 2.6.22 5/5] iw_cxgb3: Update required firmware revision to 4.0.0.
Date: Thu, 26 Apr 2007 15:21:26 -0500
To: rdreier@cisco.com, jeff@garzik.org
Cc: divy@chelsio.com, general@lists.openfabrics.org,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Message-Id: <20070426202126.24234.71523.stgit@dell3.ogc.int>
In-Reply-To: <20070426202057.24234.56383.stgit@dell3.ogc.int>
References: <20070426202057.24234.56383.stgit@dell3.ogc.int>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
User-Agent: StGIT/0.10
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Update required firmware revision to 4.0.0.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
---

 drivers/net/cxgb3/version.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 042e27e..b112317 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -38,7 +38,7 @@ #define DRV_NAME "cxgb3"
 #define DRV_VERSION "1.0-ko"
 
 /* Firmware version */
-#define FW_VERSION_MAJOR 3
-#define FW_VERSION_MINOR 3
+#define FW_VERSION_MAJOR 4
+#define FW_VERSION_MINOR 0
 #define FW_VERSION_MICRO 0
 #endif				/* __CHELSIO_VERSION_H */

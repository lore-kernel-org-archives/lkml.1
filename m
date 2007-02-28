Return-Path: <linux-kernel-owner+w=401wt.eu-S1750796AbXB1DaL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750796AbXB1DaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 22:30:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXB1DaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 22:30:11 -0500
Received: from [12.22.49.110] ([12.22.49.110]:14411 "EHLO stargate.chelsio.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750796AbXB1DaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 22:30:09 -0500
From: divy@chelsio.com
Subject: [PATCH] cxgb3 - Tag driver version
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Tue, 27 Feb 2007 19:28:14 -0800
Message-ID: <20070228032814.29900.92439.stgit@localhost.localdomain>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

This patch adds a "-ko" tag to the driver version.

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 782a6cf..82278f8 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -35,7 +35,7 @@
 #define DRV_DESC "Chelsio T3 Network Driver"
 #define DRV_NAME "cxgb3"
 /* Driver version */
-#define DRV_VERSION "1.0"
+#define DRV_VERSION "1.0-ko"
 #define FW_VERSION_MAJOR 3
 #define FW_VERSION_MINOR 2
 #endif				/* __CHELSIO_VERSION_H */

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758055AbZCMHRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbZCMHRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 03:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755416AbZCMHOe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 03:14:34 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:27619 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755140AbZCMHOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 03:14:32 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH net-next 10/10] cxgb3: update driver version
To: davem@davemloft.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Fri, 13 Mar 2009 00:14:29 -0700
Message-ID: <20090313071429.21994.93835.stgit@speedy5>
In-Reply-To: <20090313071343.21994.85719.stgit@speedy5>
References: <20090313071343.21994.85719.stgit@speedy5>
User-Agent: StGIT/0.13
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

update driver version to 1.1.1-ko

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/version.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/cxgb3/version.h b/drivers/net/cxgb3/version.h
index 6f6c30c..7bf963e 100644
--- a/drivers/net/cxgb3/version.h
+++ b/drivers/net/cxgb3/version.h
@@ -35,7 +35,7 @@
 #define DRV_DESC "Chelsio T3 Network Driver"
 #define DRV_NAME "cxgb3"
 /* Driver version */
-#define DRV_VERSION "1.1.1-ko"
+#define DRV_VERSION "1.1.2-ko"
 
 /* Firmware version */
 #define FW_VERSION_MAJOR 7


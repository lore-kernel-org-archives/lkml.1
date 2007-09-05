Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbXIEXBb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbXIEXBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 19:01:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbXIEW7K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 18:59:10 -0400
Received: from stargate.chelsio.com ([12.22.49.110]:8582 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbXIEW7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 18:59:09 -0400
From: Divy Le Ray <divy@chelsio.com>
Subject: [PATCH 7/7] cxgb3 - Update engine microcode version
To: jeff@garzik.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       swise@opengridcomputing.com
Date: Wed, 05 Sep 2007 15:58:41 -0700
Message-ID: <20070905225841.17326.6565.stgit@speedy5>
User-Agent: StGIT/0.12
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Divy Le Ray <divy@chelsio.com>

The new microcode engine version is set to 1.1.0

Signed-off-by: Divy Le Ray <divy@chelsio.com>
---

 drivers/net/cxgb3/common.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/cxgb3/common.h b/drivers/net/cxgb3/common.h
index d3f276c..3e5b0db 100644
--- a/drivers/net/cxgb3/common.h
+++ b/drivers/net/cxgb3/common.h
@@ -127,8 +127,8 @@ enum {				/* adapter interrupt-maintained statistics */
 
 enum {
 	TP_VERSION_MAJOR	= 1,
-	TP_VERSION_MINOR	= 0,
-	TP_VERSION_MICRO	= 44
+	TP_VERSION_MINOR	= 1,
+	TP_VERSION_MICRO	= 0
 };
 
 #define S_TP_VERSION_MAJOR		16

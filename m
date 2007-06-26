Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbXFZTPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbXFZTPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 15:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759321AbXFZTPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 15:15:05 -0400
Received: from ns1.coraid.com ([65.14.39.133]:25154 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758547AbXFZTPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 15:15:04 -0400
Message-Id: <1d8423c28c48a6d26516cdc707dbcdf015a4e347.1182883861.git.ecashin@coraid.com>
From: "Ed L. Cashin" <ecashin@coraid.com>
Date: Tue, 26 Jun 2007 14:50:10 -0400
Subject: [PATCH 01/12] bring driver version number to 47
To: linux-kernel@vger.kernel.org
Cc: Greg K-H <greg@kroah.com>, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were made against kernel 2.6.22-rc4.

Bring driver version number to 47.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 1d84668..2ce5ce9 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "32"
+#define VERSION "47"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.5.2.1


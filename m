Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXLGRuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXLGRuT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 12:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbXLGRuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 12:50:04 -0500
Received: from baron.coile-labs.com ([65.14.39.133]:21112 "EHLO coraid.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753520AbXLGRuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 12:50:03 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>, Greg KH <greg@kroah.com>
Subject: [PATCH 01/13] bring driver version number to 47
Date: Fri,  7 Dec 2007 12:47:59 -0500
Message-Id: <1197049691-27462-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were made against kernel 2.6.23-rc4 kernel with the
aoe-properly-initialise-the-request_queues-backing_dev_info patch
(currently in mm) applied.  They were submitted earlier and have been
modified to incorporate feedback from the kernel development
community.

Signed-off-by: Ed L. Cashin <ecashin@coraid.com>
---
 drivers/block/aoe/aoe.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/block/aoe/aoe.h b/drivers/block/aoe/aoe.h
index 07f02f8..4d0543a 100644
--- a/drivers/block/aoe/aoe.h
+++ b/drivers/block/aoe/aoe.h
@@ -1,5 +1,5 @@
 /* Copyright (c) 2006 Coraid, Inc.  See COPYING for GPL terms. */
-#define VERSION "32"
+#define VERSION "47"
 #define AOE_MAJOR 152
 #define DEVICE_NAME "aoe"
 
-- 
1.5.3.4


Return-Path: <linux-kernel-owner+w=401wt.eu-S1763528AbXLTWPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763528AbXLTWPu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 17:15:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755295AbXLTWPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 17:15:40 -0500
Received: from baron.borf.com ([65.14.39.133]:28898 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753925AbXLTWPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 17:15:39 -0500
From: "Ed L. Cashin" <ecashin@coraid.com>
To: linux-kernel@vger.kernel.org
Cc: "Ed L. Cashin" <ecashin@coraid.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 01/13] bring driver version number to 47
Date: Thu, 20 Dec 2007 17:15:49 -0500
Message-Id: <1198188961-25147-1-git-send-email-ecashin@coraid.com>
X-Mailer: git-send-email 1.5.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches were made against kernel 2.6.24-rc5-mm1 kernel.  They
were submitted earlier and have been modified to incorporate feedback
from the kernel development community.  I am resending them after
resolving conflicts with patches already in the mm tree.

The eleventh patch in the old series was obsoleted by a patch in the
2.6.24-rc5-mm1 tree, gregkh-driver-block-device.patch, and has been
omitted.  The last patch in this series is new but straightforward.

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


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758597AbXICChc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758597AbXICChc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:37:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932549AbXICC0W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:26:22 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57730 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932429AbXICCZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:25:40 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 30/32] Unionfs: update unionfs version number
Date: Sun,  2 Sep 2007 22:20:53 -0400
Message-Id: <11887860591206-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Update version number from 2.0 to 2.1 to reflect the amount of work that had
gone in since 2.0 was first released, and also to sync up with Unionfs 2.x
releases for earlier kernels.

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/linux/union_fs.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
index 9bc4e3b..7f8dcc3 100644
--- a/include/linux/union_fs.h
+++ b/include/linux/union_fs.h
@@ -12,7 +12,8 @@
 #ifndef _LINUX_UNION_FS_H
 #define _LINUX_UNION_FS_H
 
-#define UNIONFS_VERSION  "2.0"
+#define UNIONFS_VERSION  "2.1-mm"
+
 /*
  * DEFINITIONS FOR USER AND KERNEL CODE:
  */
-- 
1.5.2.2.238.g7cbf2f2


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758534AbYGERur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbYGERur (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2008 13:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756674AbYGERiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jul 2008 13:38:20 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:33100 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755983AbYGERgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2008 13:36:33 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Ext4 Developers List <linux-ext4@vger.kernel.org>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>
Cc: Shen Feng <shen@cn.fujitsu.com>, Mingming Cao <cmm@us.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: [PATCH 01/52] ext4: fix comments to say "ext4"
Date: Sat,  5 Jul 2008 13:35:27 -0400
Message-Id: <1215279378-30504-2-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 1.5.6.rc3.1.g36b7.dirty
In-Reply-To: <1215279378-30504-1-git-send-email-tytso@mit.edu>
References: <1215279378-30504-1-git-send-email-tytso@mit.edu>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shen Feng <shen@cn.fujitsu.com>

Change second/third to fourth.

Signed-off-by: Shen Feng <shen@cn.fujitsu.com>
Signed-off-by: Mingming Cao <cmm@us.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
---
 fs/ext4/ext4.h    |    2 +-
 fs/ext4/ext4_i.h  |    2 +-
 fs/ext4/ext4_sb.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 8158083..f8e22e4 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -22,7 +22,7 @@
 #include "ext4_i.h"
 
 /*
- * The second extended filesystem constants/structures
+ * The fourth extended filesystem constants/structures
  */
 
 /*
diff --git a/fs/ext4/ext4_i.h b/fs/ext4/ext4_i.h
index 26a4ae2..abf2744 100644
--- a/fs/ext4/ext4_i.h
+++ b/fs/ext4/ext4_i.h
@@ -79,7 +79,7 @@ struct ext4_ext_cache {
 };
 
 /*
- * third extended file system inode data in memory
+ * fourth extended file system inode data in memory
  */
 struct ext4_inode_info {
 	__le32	i_data[15];	/* unconverted */
diff --git a/fs/ext4/ext4_sb.h b/fs/ext4/ext4_sb.h
index 5802e69..4de9a75 100644
--- a/fs/ext4/ext4_sb.h
+++ b/fs/ext4/ext4_sb.h
@@ -25,7 +25,7 @@
 #include <linux/rbtree.h>
 
 /*
- * third extended-fs super-block data in memory
+ * fourth extended-fs super-block data in memory
  */
 struct ext4_sb_info {
 	unsigned long s_desc_size;	/* Size of a group descriptor in bytes */
-- 
1.5.6.rc3.1.g36b7.dirty


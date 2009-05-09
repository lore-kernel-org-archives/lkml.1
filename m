Return-Path: <linux-kernel-owner+w=401wt.eu-S1754254AbZEILVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254AbZEILVj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 07:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752438AbZEILV3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 07:21:29 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:64857 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbZEILV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 07:21:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=Jk18eCT2TXcGfrb7JDYVJOTs5ODblwLea60mygiC9ECcAxsGBja3Z/RFFpj7cFTjus
         UV7QKa9h++kz4PBhbkrb2Oy+VLjaAbxxHcqgLtD1PBT9oWA+XRa22yAwO7KRKSdSoRTn
         P0ayJwHvHL4SN/GudrP+FEvbBuOtQKWA1cIe0=
Subject: [PATCH] Spelling fix in btrfs code comment
From: Sankar P <sankar.curiosity@gmail.com>
To: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
       trivial@kernel.org
Content-Type: text/plain
Date: Sat, 09 May 2009 16:49:03 +0530
Message-Id: <1241867943.26731.5.camel@blr-psankar.blr.novell.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a trivial spelling error in a comment

Signed-off-by: Sankar P <sankar.curiosity@gmail.com>

---
diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index e496644..3e2c7c7 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -312,7 +312,7 @@ btrfs_lookup_first_block_group(struct btrfs_fs_info *info, u64 bytenr)
 }
 
 /*
- * return the block group that contains teh given bytenr
+ * return the block group that contains the given bytenr
  */
 struct btrfs_block_group_cache *btrfs_lookup_block_group(
 						 struct btrfs_fs_info *info,



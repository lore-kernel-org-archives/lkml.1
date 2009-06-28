Return-Path: <linux-kernel-owner+w=401wt.eu-S1760183AbZF1Qly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760183AbZF1Qly (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757190AbZF1Q2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:39 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1186 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbZF1Q2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:20 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andreas Dilger <adilger@sun.com>, "Theodore Ts'o" <tytso@mit.edu>,
       linux-ext4@vger.kernel.org
Subject: [PATCH 57/62] fs/ext4/mballoc.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:02 -0700
Message-Id: <d45c565b20589fe7884926b5174ef730de1c9442.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ext4/mballoc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 519a0a6..6b4e5ae 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -2525,7 +2525,7 @@ int ext4_mb_add_groupinfo(struct super_block *sb, ext4_group_t group,
 
 	INIT_LIST_HEAD(&meta_group_info[i]->bb_prealloc_list);
 	init_rwsem(&meta_group_info[i]->alloc_sem);
-	meta_group_info[i]->bb_free_root.rb_node = NULL;;
+	meta_group_info[i]->bb_free_root.rb_node = NULL;
 
 #ifdef DOUBLE_CHECK
 	{
-- 
1.6.3.1.10.g659a0.dirty


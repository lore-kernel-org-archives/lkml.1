Return-Path: <linux-kernel-owner+w=401wt.eu-S1760056AbZF1QlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056AbZF1QlL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756501AbZF1Q2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:34 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1181 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbZF1Q2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:18 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
Subject: [PATCH 55/62] fs/btrfs/tree-log.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:00 -0700
Message-Id: <34cccfc85bd4e32bfcc1f345d9fdb087f1afc015.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/btrfs/tree-log.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index c139222..ab326dd 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -2605,7 +2605,7 @@ static noinline int copy_items(struct btrfs_trans_handle *trans,
 								extent);
 				cs = btrfs_file_extent_offset(src, extent);
 				cl = btrfs_file_extent_num_bytes(src,
-								extent);;
+								extent);
 				if (btrfs_file_extent_compression(src,
 								  extent)) {
 					cs = 0;
-- 
1.6.3.1.10.g659a0.dirty


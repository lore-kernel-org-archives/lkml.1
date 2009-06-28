Return-Path: <linux-kernel-owner+w=401wt.eu-S1760522AbZF1QnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760522AbZF1QnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756026AbZF1Q2o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:44 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1191 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbZF1Q2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:22 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Joel Becker <joel.becker@oracle.com>, Mark Fasheh <mfasheh@suse.com>,
       ocfs2-devel@oss.oracle.com
Subject: [PATCH 59/62] fs/ocfs2/quota_global.c: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:27:04 -0700
Message-Id: <c2fa65670abb3675e51442c2f046af62c7e6195e.1246173683.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/ocfs2/quota_global.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/quota_global.c b/fs/ocfs2/quota_global.c
index edfa60c..05ed815 100644
--- a/fs/ocfs2/quota_global.c
+++ b/fs/ocfs2/quota_global.c
@@ -143,7 +143,7 @@ static int ocfs2_get_quota_block(struct inode *inode, int block,
 		err = -EIO;
 		mlog_errno(err);
 	}
-	return err;;
+	return err;
 }
 
 /* Read data from global quotafile - avoid pagecache and such because we cannot
-- 
1.6.3.1.10.g659a0.dirty


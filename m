Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXCEB7W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXCEB7W (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 20:59:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751004AbXCEB6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 20:58:25 -0500
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:38366 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbXCEBzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 20:55:16 -0500
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 09/13] fs/unionfs/: Miscellaneous coding style fixes
Date: Sun,  4 Mar 2007 20:54:59 -0500
Message-Id: <11730597051207-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.2.260.g2eb065
In-Reply-To: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
References: <11730597033857-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/super.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 176cfb6..571b589 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -320,9 +320,8 @@ static int unionfs_show_options(struct seq_file *m, struct vfsmount *mnt)
 
 		seq_printf(m, "%s=%s", path,
 			   perms & MAY_WRITE ? "rw" : "ro");
-		if (bindex != bend) {
+		if (bindex != bend)
 			seq_printf(m, ":");
-		}
 	}
 
 out:
-- 
1.5.0.2.260.g2eb065


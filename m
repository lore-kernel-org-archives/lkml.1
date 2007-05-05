Return-Path: <linux-kernel-owner+w=401wt.eu-S1753575AbXEEXMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575AbXEEXMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2007 19:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbXEEXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 May 2007 19:12:24 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:55125 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbXEEXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2007 19:12:23 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, hch@infradead.org,
       akpm@linux-foundation.org, viro@ftp.linux.org.uk,
       Trond.Myklebust@netapp.com, neilb@suse.de, mhalcrow@us.ibm.com,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 4/4] fs: Remove path_walk export
Date: Sat,  5 May 2007 19:09:34 -0400
Message-Id: <1178406574518-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.0.3.1043.g4342
In-Reply-To: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
References: <11784065741163-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/namei.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index b547af0..0262594 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2826,7 +2826,6 @@ EXPORT_SYMBOL(page_symlink_inode_operations);
 EXPORT_SYMBOL(path_lookup);
 EXPORT_SYMBOL(path_component_lookup);
 EXPORT_SYMBOL(path_release);
-EXPORT_SYMBOL(path_walk);
 EXPORT_SYMBOL(permission);
 EXPORT_SYMBOL(vfs_permission);
 EXPORT_SYMBOL(file_permission);
-- 
1.5.0.3.1043.g4342


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761825AbXFQTNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761825AbXFQTNZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 15:13:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbXFQTKN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 15:10:13 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:36871 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761120AbXFQTKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 15:10:00 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 07/16] Unionfs: Add standard copyright comment to include/linux/union_fs.h
Date: Sun, 17 Jun 2007 15:09:14 -0400
Message-Id: <11821073641057-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
References: <11821073632989-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 include/linux/union_fs.h |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
index b724031..223ccab 100644
--- a/include/linux/union_fs.h
+++ b/include/linux/union_fs.h
@@ -1,3 +1,14 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef _LINUX_UNION_FS_H
 #define _LINUX_UNION_FS_H
 
-- 
1.5.2.rc1.165.gaf9b


Return-Path: <linux-kernel-owner+w=401wt.eu-S1761753AbXEXAhW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761753AbXEXAhW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 20:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759088AbXEXAgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 20:36:25 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:40214 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757638AbXEXAgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 20:36:20 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 04/21] Unionfs: Add missing copyright notices
Date: Wed, 23 May 2007 20:35:54 -0400
Message-Id: <11799669721196-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.rc1.165.gaf9b
In-Reply-To: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
References: <11799669712090-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/stack.c               |   11 +++++++++++
 fs/unionfs/sioq.c        |    5 -----
 fs/unionfs/sioq.h        |   13 +++++++++++++
 include/linux/fs_stack.h |   11 +++++++++++
 4 files changed, 35 insertions(+), 5 deletions(-)

diff --git a/fs/stack.c b/fs/stack.c
index 9aee8fc..1f5b161 100644
--- a/fs/stack.c
+++ b/fs/stack.c
@@ -1,3 +1,14 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/fs_stack.h>
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index a1e8ffa..34e25b0 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -1,13 +1,8 @@
 /*
  * Copyright (c) 2003-2007 Erez Zadok
- * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
- * Copyright (c) 2005      Arun M. Krishnakumar
  * Copyright (c) 2004-2006 David P. Quigley
- * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
- * Copyright (c) 2003      Puja Gupta
- * Copyright (c) 2003      Harikesavan Krishnan
  * Copyright (c) 2003-2007 Stony Brook University
  * Copyright (c) 2003-2007 The Research Foundation of SUNY
  *
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index 4827514..dd6c44b 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -1,3 +1,16 @@
+/*
+ * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2005-2006 Junjiro Okajima
+ * Copyright (c) 2004-2006 David P. Quigley
+ * Copyright (c) 2003-2007 Stony Brook University
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef _SIOQ_H
 #define _SIOQ_H
 
diff --git a/include/linux/fs_stack.h b/include/linux/fs_stack.h
index 2fe2387..9a896d6 100644
--- a/include/linux/fs_stack.h
+++ b/include/linux/fs_stack.h
@@ -1,3 +1,14 @@
+/*
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ */
+
 #ifndef _LINUX_FS_STACK_H
 #define _LINUX_FS_STACK_H
 
-- 
1.5.2.rc1.165.gaf9b


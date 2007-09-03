Return-Path: <linux-kernel-owner+w=401wt.eu-S1759754AbXICCat@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbXICCat (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 22:30:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbXICCZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 22:25:35 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:57661 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756755AbXICCYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 22:24:45 -0400
From: "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       hch@infradead.org, viro@ftp.linux.org.uk, bharata@linux.vnet.ibm.com,
       j.blunck@tu-harburg.de, Erez Zadok <ezk@cs.sunysb.edu>,
       "Josef 'Jeff' Sipek" <jsipek@cs.sunysb.edu>
Subject: [PATCH 06/32] Unionfs: copyright corrections and updates
Date: Sun,  2 Sep 2007 22:20:29 -0400
Message-Id: <11887860563306-git-send-email-jsipek@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2.238.g7cbf2f2
In-Reply-To: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
References: <1188786055371-git-send-email-jsipek@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Erez Zadok <ezk@cs.sunysb.edu>

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
Signed-off-by: Josef 'Jeff' Sipek <jsipek@cs.sunysb.edu>
---
 fs/unionfs/mmap.c |    2 +-
 fs/unionfs/sioq.c |   13 +++++++------
 fs/unionfs/sioq.h |   13 +++++++------
 3 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index e03ca00..969fd16 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -10,7 +10,7 @@
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
  * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of State University of New York
+ * Copyright (c) 2003-2007 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index 575f08d..2a8c88e 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -1,10 +1,11 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
- * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
- * Copyright (c) 2005-2006 Junjiro Okajima
- * Copyright (c) 2004-2006 David P. Quigley
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006      Charles P. Wright
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006      Junjiro Okajima
+ * Copyright (c) 2006      David P. Quigley
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index 6d0d01f..bedd7af 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -1,10 +1,11 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
- * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
- * Copyright (c) 2005-2006 Junjiro Okajima
- * Copyright (c) 2004-2006 David P. Quigley
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006      Charles P. Wright
+ * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
+ * Copyright (c) 2006      Junjiro Okajima
+ * Copyright (c) 2006      David P. Quigley
+ * Copyright (c) 2006-2007 Stony Brook University
+ * Copyright (c) 2006-2007 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.5.2.2.238.g7cbf2f2


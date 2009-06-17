Return-Path: <linux-kernel-owner+w=401wt.eu-S1756710AbZFQQE4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbZFQQE4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 12:04:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZFQQEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 12:04:47 -0400
Received: from ip67-152-220-66.z220-152-67.customer.algx.net ([67.152.220.66]:11410
	"EHLO daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753209AbZFQQEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 12:04:46 -0400
From: Boaz Harrosh <bharrosh@panasas.com>
To: Jeff Garzik <jeff@garzik.org>, open-osd <osd-dev@open-osd.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/6] exofs: Remove IBM copyrights
Date: Wed, 17 Jun 2009 19:04:47 +0300
Message-Id: <1245254687-8620-1-git-send-email-bharrosh@panasas.com>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <4A391373.3050301@panasas.com>
References: <4A391373.3050301@panasas.com>
X-OriginalArrivalTime: 17 Jun 2009 16:04:49.0178 (UTC) FILETIME=[57470FA0:01C9EF65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Boaz,
Congrats on getting all the OSD stuff into 2.6.30!
I just pulled the git, and saw that the IBM copyrights are still there.
Please remove them from all files:
 * Copyright (C) 2005, 2006
 * International Business Machines

IBM has revoked all rights on the code - they gave it to me.

Thanks!
Avishay

Signed-off-by: Avishay Traeger <avishay@gmail.com>
Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 fs/exofs/common.h  |    4 +---
 fs/exofs/dir.c     |    4 +---
 fs/exofs/exofs.h   |    4 +---
 fs/exofs/file.c    |    4 +---
 fs/exofs/inode.c   |    4 +---
 fs/exofs/namei.c   |    4 +---
 fs/exofs/osd.c     |    4 +---
 fs/exofs/super.c   |    4 +---
 fs/exofs/symlink.c |    4 +---
 9 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/fs/exofs/common.h b/fs/exofs/common.h
index 24667ee..c6718e4 100644
--- a/fs/exofs/common.h
+++ b/fs/exofs/common.h
@@ -2,9 +2,7 @@
  * common.h - Common definitions for both Kernel and user-mode utilities
  *
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/dir.c b/fs/exofs/dir.c
index 65b0c8c..4cfab1c 100644
--- a/fs/exofs/dir.c
+++ b/fs/exofs/dir.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/exofs.h b/fs/exofs/exofs.h
index 0fd4c78..c413b74 100644
--- a/fs/exofs/exofs.h
+++ b/fs/exofs/exofs.h
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/file.c b/fs/exofs/file.c
index 6ed7fe4..c681003 100644
--- a/fs/exofs/file.c
+++ b/fs/exofs/file.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/inode.c b/fs/exofs/inode.c
index bb5d6ed..6c10f74 100644
--- a/fs/exofs/inode.c
+++ b/fs/exofs/inode.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/namei.c b/fs/exofs/namei.c
index 77fdd76..b7dd0c2 100644
--- a/fs/exofs/namei.c
+++ b/fs/exofs/namei.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/osd.c b/fs/exofs/osd.c
index b3d2ccb..4372542 100644
--- a/fs/exofs/osd.c
+++ b/fs/exofs/osd.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/super.c b/fs/exofs/super.c
index 8216c5b..e47b38e 100644
--- a/fs/exofs/super.c
+++ b/fs/exofs/super.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
diff --git a/fs/exofs/symlink.c b/fs/exofs/symlink.c
index 36e2d7b..4dd687c 100644
--- a/fs/exofs/symlink.c
+++ b/fs/exofs/symlink.c
@@ -1,8 +1,6 @@
 /*
  * Copyright (C) 2005, 2006
- * Avishay Traeger (avishay@gmail.com) (avishay@il.ibm.com)
- * Copyright (C) 2005, 2006
- * International Business Machines
+ * Avishay Traeger (avishay@gmail.com)
  * Copyright (C) 2008, 2009
  * Boaz Harrosh <bharrosh@panasas.com>
  *
-- 
1.6.2.1


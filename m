Return-Path: <linux-kernel-owner+w=401wt.eu-S1759898AbYG3Cqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759898AbYG3Cqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 22:46:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbYG3Cob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 22:44:31 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:46273 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136AbYG3CoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 22:44:25 -0400
From: Erez Zadok <ezk@cs.sunysb.edu>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk, hch@infradead.org, miklos@szeredi.hu,
       Erez Zadok <ezk@cs.sunysb.edu>
Subject: [PATCH 13/19] Unionfs: update copyrights
Date: Tue, 29 Jul 2008 22:43:43 -0400
Message-Id: <12173858403398-git-send-email-ezk@cs.sunysb.edu>
X-Mailer: git-send-email 1.5.2.2
X-MailKey: Erez_Zadok
In-Reply-To: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
References: <12173858291233-git-send-email-ezk@cs.sunysb.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erez Zadok <ezk@cs.sunysb.edu>
---
 fs/unionfs/commonfops.c  |    6 +++---
 fs/unionfs/copyup.c      |    6 +++---
 fs/unionfs/debug.c       |    6 +++---
 fs/unionfs/dentry.c      |    6 +++---
 fs/unionfs/dirfops.c     |    6 +++---
 fs/unionfs/dirhelper.c   |    6 +++---
 fs/unionfs/fanout.h      |    6 +++---
 fs/unionfs/file.c        |    6 +++---
 fs/unionfs/inode.c       |    6 +++---
 fs/unionfs/lookup.c      |    6 +++---
 fs/unionfs/main.c        |    6 +++---
 fs/unionfs/mmap.c        |    6 +++---
 fs/unionfs/rdstate.c     |    6 +++---
 fs/unionfs/rename.c      |    6 +++---
 fs/unionfs/sioq.c        |    6 +++---
 fs/unionfs/sioq.h        |    6 +++---
 fs/unionfs/subr.c        |    6 +++---
 fs/unionfs/super.c       |    6 +++---
 fs/unionfs/union.h       |    6 +++---
 fs/unionfs/unlink.c      |    6 +++---
 fs/unionfs/whiteout.c    |    6 +++---
 fs/unionfs/xattr.c       |    6 +++---
 include/linux/union_fs.h |    6 +++---
 23 files changed, 69 insertions(+), 69 deletions(-)

diff --git a/fs/unionfs/commonfops.c b/fs/unionfs/commonfops.c
index d64272b..5861970 100644
--- a/fs/unionfs/commonfops.c
+++ b/fs/unionfs/commonfops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/copyup.c b/fs/unionfs/copyup.c
index 55d48aa..bbd49c8 100644
--- a/fs/unionfs/copyup.c
+++ b/fs/unionfs/copyup.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/debug.c b/fs/unionfs/debug.c
index 4da4f0b..db62d22 100644
--- a/fs/unionfs/debug.c
+++ b/fs/unionfs/debug.c
@@ -1,8 +1,8 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/dentry.c b/fs/unionfs/dentry.c
index dfa4755..7f0c7f7 100644
--- a/fs/unionfs/dentry.c
+++ b/fs/unionfs/dentry.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/dirfops.c b/fs/unionfs/dirfops.c
index e35afa4..14ca7d3 100644
--- a/fs/unionfs/dirfops.c
+++ b/fs/unionfs/dirfops.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/dirhelper.c b/fs/unionfs/dirhelper.c
index 302a4a1..d936f03 100644
--- a/fs/unionfs/dirhelper.c
+++ b/fs/unionfs/dirhelper.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/fanout.h b/fs/unionfs/fanout.h
index d8977bd..4f264de 100644
--- a/fs/unionfs/fanout.h
+++ b/fs/unionfs/fanout.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005      Arun M. Krishnakumar
@@ -7,8 +7,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/file.c b/fs/unionfs/file.c
index 9b5fc58..965d071 100644
--- a/fs/unionfs/file.c
+++ b/fs/unionfs/file.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/inode.c b/fs/unionfs/inode.c
index f81ebb6..fa3c518 100644
--- a/fs/unionfs/inode.c
+++ b/fs/unionfs/inode.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/lookup.c b/fs/unionfs/lookup.c
index 93c3a14..0ae7f3a 100644
--- a/fs/unionfs/lookup.c
+++ b/fs/unionfs/lookup.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/main.c b/fs/unionfs/main.c
index 1fd67c6..6484e2b 100644
--- a/fs/unionfs/main.c
+++ b/fs/unionfs/main.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/mmap.c b/fs/unionfs/mmap.c
index febde7c..b7d4713 100644
--- a/fs/unionfs/mmap.c
+++ b/fs/unionfs/mmap.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -9,8 +9,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/rdstate.c b/fs/unionfs/rdstate.c
index 7ba1e1a..06d5374 100644
--- a/fs/unionfs/rdstate.c
+++ b/fs/unionfs/rdstate.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/rename.c b/fs/unionfs/rename.c
index ecce9da..da7d589 100644
--- a/fs/unionfs/rename.c
+++ b/fs/unionfs/rename.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/sioq.c b/fs/unionfs/sioq.c
index 0ea8436..e6f15a0 100644
--- a/fs/unionfs/sioq.c
+++ b/fs/unionfs/sioq.c
@@ -1,11 +1,11 @@
 /*
- * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2008 Erez Zadok
  * Copyright (c) 2006      Charles P. Wright
  * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2006      Junjiro Okajima
  * Copyright (c) 2006      David P. Quigley
- * Copyright (c) 2006-2007 Stony Brook University
- * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ * Copyright (c) 2006-2008 Stony Brook University
+ * Copyright (c) 2006-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/sioq.h b/fs/unionfs/sioq.h
index afb71ee..e072bf7 100644
--- a/fs/unionfs/sioq.h
+++ b/fs/unionfs/sioq.h
@@ -1,11 +1,11 @@
 /*
- * Copyright (c) 2006-2007 Erez Zadok
+ * Copyright (c) 2006-2008 Erez Zadok
  * Copyright (c) 2006      Charles P. Wright
  * Copyright (c) 2006-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2006      Junjiro Okajima
  * Copyright (c) 2006      David P. Quigley
- * Copyright (c) 2006-2007 Stony Brook University
- * Copyright (c) 2006-2007 The Research Foundation of SUNY
+ * Copyright (c) 2006-2008 Stony Brook University
+ * Copyright (c) 2006-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/subr.c b/fs/unionfs/subr.c
index dda2745..8747d20 100644
--- a/fs/unionfs/subr.c
+++ b/fs/unionfs/subr.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/super.c b/fs/unionfs/super.c
index 3b6b65a..f163c08 100644
--- a/fs/unionfs/super.c
+++ b/fs/unionfs/super.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/union.h b/fs/unionfs/union.h
index 356a146..4c7b213 100644
--- a/fs/unionfs/union.h
+++ b/fs/unionfs/union.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005      Arun M. Krishnakumar
@@ -7,8 +7,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/unlink.c b/fs/unionfs/unlink.c
index 3d6ca5f..623f68d 100644
--- a/fs/unionfs/unlink.c
+++ b/fs/unionfs/unlink.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/whiteout.c b/fs/unionfs/whiteout.c
index b1768ed..94b5241 100644
--- a/fs/unionfs/whiteout.c
+++ b/fs/unionfs/whiteout.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/fs/unionfs/xattr.c b/fs/unionfs/xattr.c
index 8001c65..93a8fce 100644
--- a/fs/unionfs/xattr.c
+++ b/fs/unionfs/xattr.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2003-2006 Charles P. Wright
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
  * Copyright (c) 2005-2006 Junjiro Okajima
@@ -8,8 +8,8 @@
  * Copyright (c) 2003-2004 Mohammad Nayyer Zubair
  * Copyright (c) 2003      Puja Gupta
  * Copyright (c) 2003      Harikesavan Krishnan
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
diff --git a/include/linux/union_fs.h b/include/linux/union_fs.h
index 9d601d2..7199458 100644
--- a/include/linux/union_fs.h
+++ b/include/linux/union_fs.h
@@ -1,8 +1,8 @@
 /*
- * Copyright (c) 2003-2007 Erez Zadok
+ * Copyright (c) 2003-2008 Erez Zadok
  * Copyright (c) 2005-2007 Josef 'Jeff' Sipek
- * Copyright (c) 2003-2007 Stony Brook University
- * Copyright (c) 2003-2007 The Research Foundation of SUNY
+ * Copyright (c) 2003-2008 Stony Brook University
+ * Copyright (c) 2003-2008 The Research Foundation of SUNY
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
-- 
1.5.2.2


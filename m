Return-Path: <linux-kernel-owner+w=401wt.eu-S1764195AbYESWBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764195AbYESWBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 18:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764417AbYESWAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 18:00:46 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:42161 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbYESWAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 18:00:45 -0400
Date: Tue, 20 May 2008 00:58:40 +0300
From: Adrian Bunk <bunk@kernel.org>
To: reiserfs-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] reiserfs/procfs.c: remove CVS keywords
Message-ID: <20080519215840.GT17716@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes CVS keywords that weren't updated for a long time 
from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 fs/reiserfs/procfs.c |    3 ---
 1 file changed, 3 deletions(-)

a41d213debad92b6672c39b577baf58641b5c54c diff --git a/fs/reiserfs/procfs.c b/fs/reiserfs/procfs.c
index b9dbeec..37173fa 100644
--- a/fs/reiserfs/procfs.c
+++ b/fs/reiserfs/procfs.c
@@ -8,8 +8,6 @@
 
 /* proc info support a la one created by Sizif@Botik.RU for PGC */
 
-/* $Id: procfs.c,v 1.1.8.2 2001/07/15 17:08:42 god Exp $ */
-
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/seq_file.h>
@@ -621,7 +619,6 @@ int reiserfs_global_version_in_proc(char *buffer, char **start,
 #endif
 
 /*
- * $Log: procfs.c,v $
  * Revision 1.1.8.2  2001/07/15 17:08:42  god
  *  . use get_super() in procfs.c
  *  . remove remove_save_link() from reiserfs_do_truncate()


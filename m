Return-Path: <linux-kernel-owner+w=401wt.eu-S1762863AbYAHRLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762863AbYAHRLj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 12:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752864AbYAHRLa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 12:11:30 -0500
Received: from smtp-102-tuesday.noc.nerim.net ([62.4.17.102]:4978 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbYAHRLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 12:11:30 -0500
Date: Tue, 8 Jan 2008 18:11:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] sysfs: Fix a copy-n-paste typo in comment
Message-ID: <20080108181124.13c8f260@hyperion.delvare>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jean Delvare <khali@linux-fr.org>
---
 fs/sysfs/dir.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.24-rc7.orig/fs/sysfs/dir.c	2007-11-07 13:21:10.000000000 +0100
+++ linux-2.6.24-rc7/fs/sysfs/dir.c	2008-01-08 17:38:24.000000000 +0100
@@ -440,7 +440,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt
 /**
  *	sysfs_remove_one - remove sysfs_dirent from parent
  *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
+ *	@sd: sysfs_dirent to be removed
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
  *	directory.  @sd is unlinked from the children list.


-- 
Jean Delvare

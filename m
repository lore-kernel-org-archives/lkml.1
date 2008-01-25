Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176AbYAYHRB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbYAYHRB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:17:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757684AbYAYHO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:14:26 -0500
Received: from mx1.suse.de ([195.135.220.2]:52412 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755550AbYAYHOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:23 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 011/196] sysfs: Fix a copy-n-paste typo in comment
Date: Thu, 24 Jan 2008 23:09:09 -0800
Message-Id: <1201245134-4876-11-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jean Delvare <khali@linux-fr.org>

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 fs/sysfs/dir.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index f281cc6..4948d9b 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -440,7 +440,7 @@ int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
 /**
  *	sysfs_remove_one - remove sysfs_dirent from parent
  *	@acxt: addrm context to use
- *	@sd: sysfs_dirent to be added
+ *	@sd: sysfs_dirent to be removed
  *
  *	Mark @sd removed and drop nlink of parent inode if @sd is a
  *	directory.  @sd is unlinked from the children list.
-- 
1.5.3.8


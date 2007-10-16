Return-Path: <linux-kernel-owner+w=401wt.eu-S1765907AbXJPJlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765907AbXJPJlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 05:41:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758181AbXJPJkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 05:40:52 -0400
Received: from gw-lon-cluster.cmcnet.net ([195.20.122.6]:34569 "EHLO
	emearelay1.cmcmarkets.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757403AbXJPJkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 05:40:52 -0400
Subject: [PATCH] sysfs: trivial: fix sysfs_create_file kerneldoc spelling
	mistake
From: Chris Malley <mail@chrismalley.co.uk>
To: Greg KH <greg@kroah.com>
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2007 10:37:04 +0100
Message-Id: <1192527424.11948.9.camel@feisty>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-MIMETrack: Itemize by SMTP Server on smtp3/CMC(Release 7.0.2FP1|January 10, 2007) at
 10/16/2007 10:40:46 AM,
	Serialize by Router on emearelay1/UK/CMC(Release 7.0.2FP1|January 10, 2007) at
 16/10/2007 10:40:52 AM,
	Serialize complete at 16/10/2007 10:40:52 AM
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Spelling error in sysfs_create_file kerneldoc.

Signed-off-by: Chris Malley <mail@chrismalley.co.uk>
---
 fs/sysfs/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 3e1cc06..ac75554 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -422,7 +422,7 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 /**
  *	sysfs_create_file - create an attribute file for an object.
  *	@kobj:	object we're creating for. 
- *	@attr:	atrribute descriptor.
+ *	@attr:	attribute descriptor.
  */
 
 int sysfs_create_file(struct kobject * kobj, const struct attribute * attr)



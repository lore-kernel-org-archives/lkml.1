Return-Path: <linux-kernel-owner+w=401wt.eu-S1760500AbXEWGDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760500AbXEWGDd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 02:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756545AbXEWGD0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 02:03:26 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:54512 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756420AbXEWGD0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 02:03:26 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [Doc] spelling fix for fs/sysfs/file.c
Date: Tue, 22 May 2007 19:23:20 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705221923.25788.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

---
commit 966fef8404d59056d8524bf94d7dff790fe1fa82
tree 1adc274bc9b8e7e420db0b0023c8b70bd294e84e
parent 0cbdc367b144a95709852c642a069ed652989520
author Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 21 May 2007 22:55:30 +0200
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Mon, 21 May 2007 22:55:30 +0200

 fs/sysfs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index b502c71..dcb8e83 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -370,7 +370,7 @@ static int sysfs_release(struct inode * inode, struct file * filp)
  * again will not get new data, or reset the state of 'poll'.
  * Reminder: this only works for attributes which actively support
  * it, and it is not possible to test an attribute from userspace
- * to see if it supports poll (Nether 'poll' or 'select' return
+ * to see if it supports poll (Neither 'poll' nor 'select' return
  * an appropriate error code).  When in doubt, set a suitable timeout value.
  */
 static unsigned int sysfs_poll(struct file *filp, poll_table *wait)

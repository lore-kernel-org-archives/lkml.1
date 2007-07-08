Return-Path: <linux-kernel-owner+w=401wt.eu-S1755149AbXGIH0s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149AbXGIH0s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 03:26:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbXGIHZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 03:25:50 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:39759 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXGIHZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 03:25:49 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 3/4][Doc] Fix typos in fs/sysfs/file.c
Date: Sun, 8 Jul 2007 18:07:22 +0200
User-Agent: KMail/1.9.7
Cc: akpm@linux-foundation.org, Randy Dunlap <rdunlap@xenotime.net>
References: <200707081754.03824.eike-kernel@sf-tec.de>
In-Reply-To: <200707081754.03824.eike-kernel@sf-tec.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707081807.22626.eike-kernel@sf-tec.de>
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

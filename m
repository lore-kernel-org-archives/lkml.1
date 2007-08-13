Return-Path: <linux-kernel-owner+w=401wt.eu-S970553AbXHMIx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970553AbXHMIx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966806AbXHMGax
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:30:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4856 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966881AbXHMGav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:30:51 -0400
Date: Sun, 12 Aug 2007 23:30:29 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, shaggy@austin.ibm.com,
       linux-kernel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
       akpm@linux-foundation.org
Subject: [PATCH] [271/2many] MAINTAINERS - JFS FILESYSTEM
Message-ID: <46bffa85.te3Zk/0ZnqI5pvA/%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 16b6def..ad68cfe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2595,6 +2595,8 @@ L:	jfs-discussion@lists.sourceforge.net
 W:	http://jfs.sourceforge.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/shaggy/jfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/jfs.txt
+F:	fs/jfs/
 
 JOURNALLING LAYER FOR BLOCK DEVICES (JBD)
 P:	Stephen Tweedie, Andrew Morton

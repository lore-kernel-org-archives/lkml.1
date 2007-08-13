Return-Path: <linux-kernel-owner+w=401wt.eu-S942568AbXHMHps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942568AbXHMHps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966377AbXHMG0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:43 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4200 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966359AbXHMG0l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:41 -0400
Date: Sun, 12 Aug 2007 23:26:21 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, teigland@redhat.com, pcaulfie@redhat.com,
       linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       akpm@linux-foundation.org
Subject: [PATCH] [156/2many] MAINTAINERS - DISTRIBUTED LOCK MANAGER
Message-ID: <46bff98d.YdH+q2D3/NHHu3IX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 0b054e1..bd0fa0e 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1526,6 +1526,8 @@ W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
+F:	Documentation/filesystems/dlmfs.txt
+F:	fs/dlm/
 
 DAVICOM FAST ETHERNET (DMFE) NETWORK DRIVER
 P:	Tobias Ringstrom

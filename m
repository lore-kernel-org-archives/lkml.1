Return-Path: <linux-kernel-owner+w=401wt.eu-S942332AbXHMIQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942332AbXHMIQl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:16:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965976AbXHMG2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4504 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965621AbXHMG2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:36 -0400
Date: Sun, 12 Aug 2007 23:28:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, swhiteho@redhat.com,
       linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
       akpm@linux-foundation.org
Subject: [PATCH] [208/2many] MAINTAINERS - GFS2 FILE SYSTEM
Message-ID: <46bffa01.umS2rSd+AoRJwoFx%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d8063ee..b4183e7 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1992,6 +1992,9 @@ W:	http://sources.redhat.com/cluster/
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-fixes.git
 T:	git kernel.org:/pub/scm/linux/kernel/git/steve/gfs2-2.6-nmw.git
 S:	Supported
+F:	/Documentation/filesystems/gfs2.txt
+F:	fs/gfs2/
+F:	include/linux/gfs2_ondisk.h
 
 GIGASET ISDN DRIVERS
 P:	Hansjoerg Lipp

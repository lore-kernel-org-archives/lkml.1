Return-Path: <linux-kernel-owner+w=401wt.eu-S942642AbXHMJmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942642AbXHMJmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966580AbXHMGdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:06 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1279 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967077AbXHMGdD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:03 -0400
Date: Sun, 12 Aug 2007 23:32:51 -0700
From: joe@perches.com
To: trond.myklebust@fys.uio.no, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [344/2many] MAINTAINERS - NFS CLIENT
Message-ID: <46bffb13.g6PWKhDCxXTpAZFm%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a8fb231..1f81c05 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3308,6 +3308,12 @@ P:	Trond Myklebust
 M:	trond.myklebust@fys.uio.no
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	fs/nfs/
+F:	fs/nfs_common/
+F:	fs/nfsctl.c
+F:	fs/nfsd/
+F:	include/linux/nfs*
+F:	include/linux/nfsd/
 
 NI5010 NETWORK DRIVER
 P:	Jan-Pascal van Best

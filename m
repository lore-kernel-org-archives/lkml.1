Return-Path: <linux-kernel-owner+w=401wt.eu-S967370AbXHMMCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967370AbXHMMCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967419AbXHMGkK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:10 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2468 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965208AbXHMGkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:04 -0400
Date: Sun, 12 Aug 2007 23:39:51 -0700
From: joe@perches.com
To: xfs@oss.sgi.com, xfs-masters@oss.sgi.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [546/2many] MAINTAINERS - XFS FILESYSTEM
Message-ID: <46bffcb7.3Lt7AxfIDv77MFZq%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8395aba..e400d13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5167,6 +5167,8 @@ L:	xfs@oss.sgi.com
 W:	http://oss.sgi.com/projects/xfs
 T:	git git://oss.sgi.com:8090/xfs/xfs-2.6.git
 S:	Supported
+F:	Documentation/filesystems/xfs.txt
+F:	fs/xfs/
 
 XILINX UARTLITE SERIAL DRIVER
 P:	Peter Korsgaard

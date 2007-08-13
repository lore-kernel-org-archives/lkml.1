Return-Path: <linux-kernel-owner+w=401wt.eu-S942322AbXHMIGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942322AbXHMIGz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966614AbXHMG2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:28:11 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4419 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966603AbXHMG2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:06 -0400
Date: Sun, 12 Aug 2007 23:27:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, matthew@wil.cx,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH] [196/2many] MAINTAINERS - FILE LOCKING (flock() and
 fcntl()/lockf())
Message-ID: <46bff9e9.67UvIyt78DK68K9G%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 35f1636..fbdd316 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1883,6 +1883,10 @@ P:	Matthew Wilcox
 M:	matthew@wil.cx
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
+F:	include/linux/fcntl.h
+F:	include/linux/fs.h
+F:	fs/fcntl.c
+F:	fs/locks.c
 
 FILESYSTEMS (VFS and infrastructure)
 P:	Alexander Viro

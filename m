Return-Path: <linux-kernel-owner+w=401wt.eu-S943745AbXHMJrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943745AbXHMJrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966901AbXHMGdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:33:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1342 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967098AbXHMGdW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:33:22 -0400
Date: Sun, 12 Aug 2007 23:32:58 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-ntfs-dev@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       aia21@cantab.net
Subject: [PATCH] [348/2many] MAINTAINERS - NTFS FILESYSTEM
Message-ID: <46bffb1a.JeEiM62+unVlAI47%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 378ad04..fa4b1bf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3350,6 +3350,8 @@ L:	linux-kernel@vger.kernel.org
 W:	http://linux-ntfs.sf.net/
 T:	git kernel.org:/pub/scm/linux/kernel/git/aia21/ntfs-2.6.git
 S:	Maintained
+F:	Documentation/filesystems/ntfs.txt
+F:	fs/ntfs/
 
 NVIDIA (rivafb and nvidiafb) FRAMEBUFFER DRIVER
 P:	Antonino Daplas

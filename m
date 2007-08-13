Return-Path: <linux-kernel-owner+w=401wt.eu-S935093AbXHMLwF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbXHMLwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:52:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966541AbXHMGji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:38 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2382 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967447AbXHMGjf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:35 -0400
Date: Sun, 12 Aug 2007 23:39:11 -0700
From: joe@perches.com
To: user-mode-linux-user@lists.sourceforge.net,
       user-mode-linux-devel@lists.sourceforge.net,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jdike@karaya.com, akpm@linux-foundation.org
Subject: [PATCH] [525/2many] MAINTAINERS - USER-MODE LINUX
Message-ID: <46bffc8f.k8F7SBEYGP7ozPij%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c50b6b1..7d1f87d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4964,6 +4964,9 @@ L:	user-mode-linux-devel@lists.sourceforge.net
 L:	user-mode-linux-user@lists.sourceforge.net
 W:	http://user-mode-linux.sourceforge.net
 S:	Maintained
+F:	Documentation/uml/UserModeLinux-HOWTO.txt
+F:	arch/um/
+F:	include/asm-um/
 
 FAT/VFAT/MSDOS FILESYSTEM:
 P:	OGAWA Hirofumi

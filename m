Return-Path: <linux-kernel-owner+w=401wt.eu-S943794AbXHMLtl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943794AbXHMLtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967454AbXHMGjc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:32 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2360 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967448AbXHMGj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:28 -0400
Date: Sun, 12 Aug 2007 23:39:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Subject: [PATCH] [526/2many] MAINTAINERS - FAT/VFAT/MSDOS FILESYSTEM:
Message-ID: <46bffc91.CnQQ84QxqWdgjlKj%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 7d1f87d..3fdf6f0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4973,6 +4973,10 @@ P:	OGAWA Hirofumi
 M:	hirofumi@mail.parknet.co.jp
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/filesystems/vfat.txt
+F:	fs/fat/
+F:	fs/msdos/
+F:	fs/vfat/
 
 VIA 82Cxxx AUDIO DRIVER (old OSS driver)
 P:	Jeff Garzik

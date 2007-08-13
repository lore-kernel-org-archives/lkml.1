Return-Path: <linux-kernel-owner+w=401wt.eu-S968899AbXHMLsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968899AbXHMLsH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967443AbXHMGj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2347 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967438AbXHMGjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:22 -0400
Date: Sun, 12 Aug 2007 23:39:09 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       royale@zerezo.com, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [524/2many] MAINTAINERS - USB ZR364XX DRIVER
Message-ID: <46bffc8d.w0w5kuDQgfOrGPw9%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 6cfd315..c50b6b1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4954,6 +4954,8 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
+F:	Documentation/video4linux/zr364xx.txt
+F:	drivers/media/video/zr364xx.c
 
 USER-MODE LINUX
 P:	Jeff Dike

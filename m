Return-Path: <linux-kernel-owner+w=401wt.eu-S944545AbXHMLnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944545AbXHMLnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967424AbXHMGjN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:13 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2302 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967401AbXHMGjJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:09 -0400
Date: Sun, 12 Aug 2007 23:38:55 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       luca.risolia@studio.unibo.it, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [517/2many] MAINTAINERS - USB SN9C1xx DRIVER
Message-ID: <46bffc7f.HJr0ivqzF3pXDfzA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 91a66c9..f177a2b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4884,6 +4884,8 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/sn9c102.txt
+F:	drivers/media/video/sn9c102/
 
 USB SUBSYSTEM
 P:	Greg Kroah-Hartman

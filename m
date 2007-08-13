Return-Path: <linux-kernel-owner+w=401wt.eu-S943994AbXHMLpl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943994AbXHMLpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:45:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966931AbXHMGjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:19 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2328 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967411AbXHMGjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:17 -0400
Date: Sun, 12 Aug 2007 23:39:03 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       luca.risolia@studio.unibo.it, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [521/2many] MAINTAINERS - USB W996[87]CF DRIVER
Message-ID: <46bffc87.0FDH4iHzNHTUfK3D%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4dba8ee..a5c8d86 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4925,6 +4925,8 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	Documentation/video4linux/w9968cf.txt
+F:	drivers/media/video/w996*
 
 USB ZC0301 DRIVER
 P:	Luca Risolia

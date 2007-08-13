Return-Path: <linux-kernel-owner+w=401wt.eu-S967303AbXHML0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967303AbXHML0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965935AbXHMGiY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:38:24 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2171 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S939202AbXHMGiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:38:23 -0400
Date: Sun, 12 Aug 2007 23:38:09 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       luca.risolia@studio.unibo.it, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [494/2many] MAINTAINERS - USB ET61X[12]51 DRIVER
Message-ID: <46bffc51.05c3v77tDH2ra/34%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5bec508..be2b366 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4679,6 +4679,7 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	drivers/media/video/et61x251/
 
 USB GADGET/PERIPHERAL SUBSYSTEM
 P:	David Brownell

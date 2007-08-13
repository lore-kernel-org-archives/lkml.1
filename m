Return-Path: <linux-kernel-owner+w=401wt.eu-S932823AbXHMLq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932823AbXHMLq3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967437AbXHMGjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:21 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2333 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967413AbXHMGjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:19 -0400
Date: Sun, 12 Aug 2007 23:39:05 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, torvalds@linux-foundation.org,
       luca.risolia@studio.unibo.it, linux-usb-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [522/2many] MAINTAINERS - USB ZC0301 DRIVER
Message-ID: <46bffc89.PIA71zZdwpNgtQtJ%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a5c8d86..16ddb78 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4935,6 +4935,8 @@ L:	linux-usb-devel@lists.sourceforge.net
 L:	video4linux-list@redhat.com
 W:	http://www.linux-projects.org
 S:	Maintained
+F:	ocumentation/video4linux/zc0301.txt
+F:	drivers/media/video/zc0301/
 
 USB ZD1201 DRIVER
 P:	Jeroen Vreeken

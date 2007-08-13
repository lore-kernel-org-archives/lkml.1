Return-Path: <linux-kernel-owner+w=401wt.eu-S944974AbXHMLyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S944974AbXHMLyZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967472AbXHMGjp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:39:45 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2398 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967464AbXHMGjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:39:42 -0400
Date: Sun, 12 Aug 2007 23:39:28 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
       torvalds@linux-foundation.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [534/2many] MAINTAINERS - VIDEO FOR LINUX
Message-ID: <46bffca0.bx1Cr4B33dN1FJPN%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3e962b1..25bc39a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5046,6 +5046,10 @@ L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/
+F:	drivers/media/
+F:	include/linux/videodev2.h
+F:	include/media/
 
 VT1211 HARDWARE MONITOR DRIVER
 P:	Juerg Haefliger

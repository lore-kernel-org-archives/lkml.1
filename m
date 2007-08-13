Return-Path: <linux-kernel-owner+w=401wt.eu-S939584AbXHMHWV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939584AbXHMHWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:22:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937750AbXHMGZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:25:20 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3963 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937370AbXHMGZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:25:16 -0400
Date: Sun, 12 Aug 2007 23:25:02 -0700
From: joe@perches.com
To: video4linux-list@redhat.com, v4l-dvb-maintainer@linuxtv.org,
       torvalds@linux-foundation.org, mchehab@infradead.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [116/2many] MAINTAINERS - BTTV VIDEO4LINUX DRIVER
Message-ID: <46bff93e.aNfWAJCU2lU2xp7Q%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 4ad8cd5..c5d9bbe 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1129,6 +1129,8 @@ L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	Documentation/video4linux/bttv/
+F:	drivers/media/video/bt8xx/bttv*
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:   	Jonathan Corbet

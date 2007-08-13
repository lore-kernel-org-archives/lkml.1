Return-Path: <linux-kernel-owner+w=401wt.eu-S942694AbXHMHuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942694AbXHMHuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966431AbXHMG0y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:26:54 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4232 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966416AbXHMG0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:52 -0400
Date: Sun, 12 Aug 2007 23:26:40 -0700
From: joe@perches.com
To: v4l-dvb-maintainer@linuxtv.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [165/2many] MAINTAINERS - DVB SUBSYSTEM AND DRIVERS
Message-ID: <46bff9a0.e/9yM2yHeGs6e+wx%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 3d75c15..8c79559 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1605,10 +1605,14 @@ F:	drivers/net/wan/dscc4.c
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
 M:	v4l-dvb-maintainer@linuxtv.org
-L: 	linux-dvb@linuxtv.org (subscription required)
+L:	linux-dvb@linuxtv.org (subscribers-only)
 W:	http://linuxtv.org/
 T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
 S:	Maintained
+F:	drivers/media/dvb/
+F:	drivers/media/video/*/*dvb.c
+F:	drivers/media/video/*dvb.c
+F:	include/linux/dvb/
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer

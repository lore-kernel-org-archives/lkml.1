Return-Path: <linux-kernel-owner+w=401wt.eu-S939668AbXHMHJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939668AbXHMHJ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965382AbXHMGYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:34 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3826 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965949AbXHMGYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:30 -0400
Date: Sun, 12 Aug 2007 23:22:52 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jayalk@intworks.biz, akpm@linux-foundation.org
Subject: [PATCH] [47/2many] MAINTAINERS - ARC FRAMEBUFFER DRIVER
Message-ID: <46bff8bc.sB/cTHJb5VsPA4yO%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 966d1ec..435bafd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -450,6 +450,8 @@ ARC FRAMEBUFFER DRIVER
 P:	Jaya Kumar
 M:	jayalk@intworks.biz
 S:	Maintained
+F:	drivers/video/arcfb.c
+F:	drivers/video/fb_defio.c
 
 ARM MFM AND FLOPPY DRIVERS
 P:	Ian Molton

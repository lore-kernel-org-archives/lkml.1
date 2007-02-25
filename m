Return-Path: <linux-kernel-owner+w=401wt.eu-S933602AbXBYAIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933602AbXBYAIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 19:08:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933603AbXBYAIs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 19:08:48 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:43400 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933602AbXBYAIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 19:08:47 -0500
Date: Sun, 25 Feb 2007 01:08:47 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] remove the jffs MAINTAINERS entry
Message-ID: <20070225000847.GV12392@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the MAINTAINERS entry for the removed jffs 
filesystem.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

--- linux-2.6.20-mm2/MAINTAINERS.old	2007-02-24 23:31:48.000000000 +0100
+++ linux-2.6.20-mm2/MAINTAINERS	2007-02-24 23:32:04.000000000 +0100
@@ -1956,13 +1956,6 @@
 W:	http://www.melware.de
 S:	Maintained
 
-JOURNALLING FLASH FILE SYSTEM (JFFS)
-P:	Axis Communications AB
-M:	jffs-dev@axis.com
-L:	jffs-dev@axis.com
-W:	http://www.developer.axis.com/software/jffs/
-S:	Maintained
-
 JOURNALLING FLASH FILE SYSTEM V2 (JFFS2)
 P:	David Woodhouse
 M:	dwmw2@infradead.org


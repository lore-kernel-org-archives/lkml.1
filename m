Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbXHMK3h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbXHMK3h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 06:29:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967229AbXHMGfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:35:39 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1732 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967272AbXHMGfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:35:31 -0400
Date: Sun, 12 Aug 2007 23:35:17 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgilbert@interlog.com,
       akpm@linux-foundation.org
Subject: [PATCH] [419/2many] MAINTAINERS - SCSI SG DRIVER
Message-ID: <46bffba5.d9TWe7rJKF8n3g9N%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d7a1c74..c156f9f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3989,6 +3989,8 @@ M:	dgilbert@interlog.com
 L:	linux-scsi@vger.kernel.org
 W:	http://www.torque.net/sg
 S:	Maintained
+F:	drivers/scsi/sg.c
+F:	include/scsi/sg.h
 
 SCSI SUBSYSTEM
 P:	James E.J. Bottomley

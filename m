Return-Path: <linux-kernel-owner+w=401wt.eu-S969213AbXHMIXp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969213AbXHMIXp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:23:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966603AbXHMG3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:00 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4569 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966598AbXHMG27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:28:59 -0400
Date: Sun, 12 Aug 2007 23:28:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, mike.miller@hp.com,
       linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
       akpm@linux-foundation.org
Subject: [PATCH] [222/2many] MAINTAINERS - HEWLETT-PACKARD SMART CISS RAID DRIVER (cciss)
Message-ID: <46bffa1c.mAhsZ7dHKQrKdr+X%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 2b16863..76bacfd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2127,6 +2127,9 @@ P:	Mike Miller
 M:	mike.miller@hp.com
 L:	iss_storagedev@hp.com
 S:	Supported
+F:	Documentation/cciss.txt
+F:	drivers/block/cciss*
+F:	include/linux/cciss_ioctl.h
 
 HOST AP DRIVER
 P:	Jouni Malinen

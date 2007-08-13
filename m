Return-Path: <linux-kernel-owner+w=401wt.eu-S969643AbXHMIbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969643AbXHMIbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 04:31:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966813AbXHMG3d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:29:33 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4653 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966743AbXHMG3b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:29:31 -0400
Date: Sun, 12 Aug 2007 23:29:18 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       ipslinux@adaptec.com, akpm@linux-foundation.org
Subject: [PATCH] [239/2many] MAINTAINERS - IBM ServeRAID RAID DRIVER
Message-ID: <46bffa3e.S2q3Isql06XmOVDT%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a2e3afc..99e4822 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2268,6 +2268,7 @@ P:	Dave Jeffery
 M:	ipslinux@adaptec.com
 W:	http://www.developer.ibm.com/welcome/netfinity/serveraid.html
 S:	Supported
+F:	drivers/scsi/ips.*
 
 IDE SUBSYSTEM
 P:	Bartlomiej Zolnierkiewicz

Return-Path: <linux-kernel-owner+w=401wt.eu-S968388AbXHMMDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968388AbXHMMDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 08:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967526AbXHMGkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:40:12 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2474 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967451AbXHMGkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:40:06 -0400
Date: Sun, 12 Aug 2007 23:26:42 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-eata@i-connect.net,
       akpm@linux-foundation.org
Subject: [PATCH] [166/2many] MAINTAINERS - EATA-DMA SCSI DRIVER
Message-ID: <46bff9a2.xVArxjKoYTQQ0aCA%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 8c79559..a8b11ba 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1616,8 +1616,10 @@ F:	include/linux/dvb/
 
 EATA-DMA SCSI DRIVER
 P:	Michael Neuffer
-L:	linux-eata@i-connect.net, linux-scsi@vger.kernel.org
+L:	linux-eata@i-connect.net
+L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA ISA/EISA/PCI SCSI DRIVER
 P:	Dario Ballabio

Return-Path: <linux-kernel-owner+w=401wt.eu-S968355AbXHMH7A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968355AbXHMH7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:59:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966517AbXHMG1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:31 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4345 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966498AbXHMG10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:26 -0400
Date: Sun, 12 Aug 2007 23:27:13 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, james.smart@emulex.com,
       akpm@linux-foundation.org
Subject: [PATCH] [182/2many] MAINTAINERS - EMULEX LPFC FC SCSI DRIVER
Message-ID: <46bff9c1.jydIZY06No6rdZtX%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index d5bceb3..6da519c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1759,6 +1759,7 @@ M:	james.smart@emulex.com
 L:	linux-scsi@vger.kernel.org
 W:	http://sourceforge.net/projects/lpfcxxxx
 S:	Supported
+F:	drivers/scsi/lpfc/
 
 EPSON 1355 FRAMEBUFFER DRIVER
 P:	Christopher Hoover

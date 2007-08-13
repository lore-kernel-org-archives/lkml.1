Return-Path: <linux-kernel-owner+w=401wt.eu-S968490AbXHMH6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968490AbXHMH6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966504AbXHMG12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:28 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4343 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965757AbXHMG10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:27:26 -0400
Date: Sun, 12 Aug 2007 23:27:11 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, raisch@de.ibm.com,
       linux-kernel@vger.kernel.org, hnguyen@de.ibm.com,
       general@lists.openfabrics.org, akpm@linux-foundation.org
Subject: [PATCH] [181/2many] MAINTAINERS - EHCA (IBM GX bus InfiniBand
 adapter) DRIVER:
Message-ID: <46bff9bf.jz1f6LaulAG1xTlK%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ad6dc93..d5bceb3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1751,6 +1751,7 @@ P:	Christoph Raisch
 M:	raisch@de.ibm.com
 L:	general@lists.openfabrics.org
 S:	Supported
+F:	drivers/infiniband/hw/ehca/
 
 EMULEX LPFC FC SCSI DRIVER
 P:	James Smart

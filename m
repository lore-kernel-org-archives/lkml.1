Return-Path: <linux-kernel-owner+w=401wt.eu-S942409AbXHMHv3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S942409AbXHMHv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:51:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763239AbXHMG1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:27:00 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4249 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966442AbXHMG06 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:26:58 -0400
Date: Sun, 12 Aug 2007 23:26:44 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ballabio_dario@emc.com,
       akpm@linux-foundation.org
Subject: [PATCH] [167/2many] MAINTAINERS - EATA ISA/EISA/PCI SCSI DRIVER
Message-ID: <46bff9a4.6Dp5DZiuXSmt00j5%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index a8b11ba..144c052 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1626,6 +1626,7 @@ P:	Dario Ballabio
 M:	ballabio_dario@emc.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	drivers/scsi/eata*
 
 EATA-PIO SCSI DRIVER
 P:	Michael Neuffer

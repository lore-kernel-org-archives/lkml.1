Return-Path: <linux-kernel-owner+w=401wt.eu-S970959AbXHMJB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S970959AbXHMJB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966918AbXHMGbO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:31:14 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:4925 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966348AbXHMGbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:31:09 -0400
Date: Sun, 12 Aug 2007 23:30:55 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       James.Bottomley@HansenPartnership.com
Subject: [PATCH] [284/2many] MAINTAINERS - LASI 53c700 driver for PARISC
Message-ID: <46bffa9f.e33hDvc5+YmJDs4U%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 5c4d564..f8a3640 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2731,6 +2731,8 @@ P:	James E.J. Bottomley
 M:	James.Bottomley@HansenPartnership.com
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
+F:	Documentation/scsi/53c700.txt
+F:	drivers/scsi/53c700*
 
 LED SUBSYSTEM
 P:	Richard Purdie

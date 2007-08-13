Return-Path: <linux-kernel-owner+w=401wt.eu-S971571AbXHMJS6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S971571AbXHMJS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 05:18:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966952AbXHMGcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:32:09 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:1108 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967012AbXHMGcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:32:06 -0400
Date: Sun, 12 Aug 2007 23:31:50 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, megaraidlinux@lsi.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [313/2many] MAINTAINERS - MEGARAID SCSI DRIVERS
Message-ID: <46bffad6.Dzr+ze1HP0GSRrIG%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index ab3a4ae..2bb7a99 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3015,6 +3015,9 @@ M:	megaraidlinux@lsi.com
 S:	linux-scsi@vger.kernel.org
 W:	http://megaraid.lsilogic.com
 S:	Maintained
+F:	Documentation/scsi/megaraid.txt
+F:	drivers/scsi/megaraid.*
+F:	drivers/scsi/megaraid/
 
 MEMORY MANAGEMENT
 L:	linux-mm@kvack.org

Return-Path: <linux-kernel-owner+w=401wt.eu-S1765567AbXHMLKZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765567AbXHMLKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 07:10:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761450AbXHMGhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:37:47 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:2054 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967397AbXHMGhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:37:25 -0400
Date: Sun, 12 Aug 2007 23:37:12 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, nagar@watson.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] [474/2many] MAINTAINERS - TASKSTATS STATISTICS INTERFACE
Message-ID: <46bffc18.IUgu7A7PjyZe1Oa2%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index c8ce755..36186ab 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4495,6 +4495,9 @@ P:	Shailabh Nagar
 M:	nagar@watson.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
+F:	Documentation/accounting/taskstats*
+F:	include/linux/taskstats*
+F:	kernel/taskstats.c
 
 TI PARALLEL LINK CABLE DRIVER
 P:	Romain Lievin

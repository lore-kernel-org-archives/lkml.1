Return-Path: <linux-kernel-owner+w=401wt.eu-S1759398AbXHMHCp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398AbXHMHCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 03:02:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966013AbXHMGYP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 02:24:15 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3775 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966074AbXHMGYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 02:24:13 -0400
Date: Sun, 12 Aug 2007 23:23:53 -0700
From: joe@perches.com
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       dwmw2@infradead.org, akpm@linux-foundation.org
Subject: [PATCH] [79/2many] MAINTAINERS - AUDIT SUBSYSTEM
Message-ID: <46bff8f9.mRTfuozRo5YWPz2f%joe@perches.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Add file pattern to MAINTAINER entry

Signed-off-by: Joe Perches <joe@perches.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 44ab6e3..0042bf6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -799,6 +799,8 @@ L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained
+F:	include/linux/audit*
+F:	kernel/audit*
 
 AUXILIARY DISPLAY DRIVERS
 P:	Miguel Ojeda Sandonis

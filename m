Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbXG1QmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbXG1QmA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jul 2007 12:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753752AbXG1Qlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jul 2007 12:41:51 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59530 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbXG1Qlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jul 2007 12:41:50 -0400
Date: Sat, 28 Jul 2007 09:46:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-audit@redhat.com, dwmw2@infradead.org
Subject: [PATCH] audit m-l is members-only
Message-Id: <20070728094611.b8f17573.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

audit m-l is "members-only".

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.23-rc1-mm1.orig/MAINTAINERS
+++ linux-2.6.23-rc1-mm1/MAINTAINERS
@@ -679,7 +679,7 @@ S:	Maintained
 AUDIT SUBSYSTEM
 P:	David Woodhouse
 M:	dwmw2@infradead.org
-L:	linux-audit@redhat.com
+L:	linux-audit@redhat.com (subscribers-only)
 W:	http://people.redhat.com/sgrubb/audit/
 T:	git kernel.org:/pub/scm/linux/kernel/git/dwmw2/audit-2.6.git
 S:	Maintained

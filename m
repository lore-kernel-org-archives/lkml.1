Return-Path: <linux-kernel-owner+w=401wt.eu-S1762116AbYFMJdu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762116AbYFMJdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 05:33:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYFMJdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 05:33:42 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36179 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521AbYFMJdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 05:33:42 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: nagar1234@in.ibm.com, Balbir Singh <balbir@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org
Date: Fri, 13 Jun 2008 15:03:30 +0530
Message-Id: <20080613093330.14236.71816.sendpatchset@localhost.localdomain>
Subject: [PATCH] Update delay accounting maintainer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Update the delay accounting and taskstats maintainer to Balbir Singh.
I spoke to Shailabh and he is now busy with other things.

Cc: nagar1234@in.ibm.com
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 MAINTAINERS |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN MAINTAINERS~update-delayacct-maintainer MAINTAINERS
--- linux-2.6.26-rc5/MAINTAINERS~update-delayacct-maintainer	2008-06-12 13:12:58.000000000 +0530
+++ linux-2.6.26-rc5-balbir/MAINTAINERS	2008-06-12 13:13:29.000000000 +0530
@@ -3218,8 +3218,8 @@ L:	netdev@vger.kernel.org
 S:	Maintained
 
 PER-TASK DELAY ACCOUNTING
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
@@ -3921,8 +3921,8 @@ M:	hch@infradead.org
 S:	Maintained
 
 TASKSTATS STATISTICS INTERFACE
-P:	Shailabh Nagar
-M:	nagar@watson.ibm.com
+P:	Balbir Singh
+M:	balbir@linux.vnet.ibm.com
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL

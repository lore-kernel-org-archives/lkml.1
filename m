Return-Path: <linux-kernel-owner+w=401wt.eu-S1757440AbXI2AT6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757440AbXI2AT6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 20:19:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753374AbXI2ATv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 20:19:51 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:58833
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752748AbXI2ATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 20:19:51 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH]: Documentation/vm/00-INDEX
Date: Fri, 28 Sep 2007 19:19:47 -0500
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709281919.47595.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Landley <rob@landley.net>

Add a 00-INDEX file for Documentation/vm

Signed-off-by: Rob Landley <rob@landley.net>
---

 Documentation/vm/00-INDEX |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- /dev/null	2007-04-23 10:59:00.000000000 -0500
+++ kdocs/Documentation/vm/00-INDEX	2007-09-28 19:15:48.000000000 -0500
@@ -0,0 +1,20 @@
+00-INDEX
+	- This file
+balance
+	- Zone balancing (making sure each memory zone has enough free pages).
+hugetlbpage.txt
+	- Using huge memory pages to speed up applications with large data sets.
+locking
+	- How locking and synchronization is done in the Linux vm code.
+numa
+	- Intro to Non-Uniform Memory Access systems running Linux.
+numa_memory_policy.txt
+	- Controlling which NUMA nodes a process allocates memory from.
+overcommit-accounting
+	- Whether it's ok to allocate more virtual memory than physical + swap.
+page_migration
+	- Moving a running process's memory to a different NUMA node.
+slabinfo.c
+	- Tool to get reports about slabs
+slub.txt
+	- Short users guide for SLUB

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

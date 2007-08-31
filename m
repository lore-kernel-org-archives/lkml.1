Return-Path: <linux-kernel-owner+w=401wt.eu-S966252AbXHaVYV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966252AbXHaVYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 17:24:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760905AbXHaVYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 17:24:07 -0400
Received: from wx-out-0506.google.com ([66.249.82.235]:33229 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761336AbXHaVYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 17:24:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=r8Qay8XkYOmbCCDSMAipEx3MWj9HedKq9A/O/Y/TUivf015LcUHSu9IiDlXsv+vTnBizLCZ+jgOe+gbk9/4ke+Lrzug43NIdUL/yvKEMQBJ+qLoDy7rZf3vnOHWNLMhAvSr037GfCU/RMHEaperdYkyYqLgkZiRmC0yu9bV9zvY=
From: Jesper Juhl <jesper.juhl@gmail.com>
To: linux-doc@vger.kernel.org
Subject: [PATCH 1/5] Add a missing 00-INDEX file for Documentation/vm/
Date: Fri, 31 Aug 2007 23:20:59 +0200
User-Agent: KMail/1.9.7
Cc: Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@xenotime.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jesper Juhl <jesper.juhl@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200708312320.59341.jesper.juhl@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a 00-INDEX file to Documentation/vm/


Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
---

 00-INDEX |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- /dev/null	2005-11-21 04:22:37.000000000 +0100
+++ Documentation/vm/00-INDEX	2007-08-31 23:16:00.000000000 +0200
@@ -0,0 +1,20 @@
+00-INDEX
+	- this file.
+balance
+	- various information on memory balancing.
+hugetlbpage.txt
+	- a brief summary of hugetlbpage support in the Linux kernel.
+locking
+	- info on how locking and synchronization is done in the Linux vm code.
+numa
+	- information about NUMA specific code in the Linux vm.
+numa_memory_policy.txt
+	- documentation of concepts and APIs of the 2.6 memory policy support.
+overcommit-accounting
+	- description of the Linux kernels overcommit handling modes.
+page_migration
+	- description of page migration in NUMA systems.
+slabinfo.c
+	- source code for a tool to get reports about slabs.
+slub.txt
+	- a short users guide for SLUB.




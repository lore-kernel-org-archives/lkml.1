Return-Path: <linux-kernel-owner+w=401wt.eu-S1754148AbZKWRns@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148AbZKWRns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 12:43:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZKWRnr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 12:43:47 -0500
Received: from hera.kernel.org ([140.211.167.34]:41559 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753759AbZKWRnk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 12:43:40 -0500
Date: Mon, 23 Nov 2009 17:43:07 GMT
From: "tip-bot for K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       stern@rowland.harvard.edu, fweisbec@gmail.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       stern@rowland.harvard.edu, fweisbec@gmail.com, tglx@linutronix.de,
       prasad@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <20091123154713.GA5593@in.ibm.com>
References: <20091123154713.GA5593@in.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] hw-breakpoint: Attribute authorship of hw-breakpoint related files
Message-ID: <tip-ba6909b719a5ccc0c8100d2895bb7ff557b2eeae@git.kernel.org>
Git-Commit-ID: ba6909b719a5ccc0c8100d2895bb7ff557b2eeae
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba6909b719a5ccc0c8100d2895bb7ff557b2eeae
Gitweb:     http://git.kernel.org/tip/ba6909b719a5ccc0c8100d2895bb7ff557b2eeae
Author:     K.Prasad <prasad@linux.vnet.ibm.com>
AuthorDate: Mon, 23 Nov 2009 21:17:13 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 23 Nov 2009 18:18:29 +0100

hw-breakpoint: Attribute authorship of hw-breakpoint related files

Attribute authorship to developers of hw-breakpoint related
files.

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20091123154713.GA5593@in.ibm.com>
[ v2: moved it to latest -tip ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/hw_breakpoint.c         |    4 ++++
 kernel/hw_breakpoint.c                  |    4 ++++
 samples/hw_breakpoint/data_breakpoint.c |    2 ++
 3 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/hw_breakpoint.c b/arch/x86/kernel/hw_breakpoint.c
index 752daeb..4d267fb 100644
--- a/arch/x86/kernel/hw_breakpoint.c
+++ b/arch/x86/kernel/hw_breakpoint.c
@@ -16,6 +16,10 @@
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) 2009 IBM Corporation
  * Copyright (C) 2009 Frederic Weisbecker <fweisbec@gmail.com>
+ *
+ * Authors: Alan Stern <stern@rowland.harvard.edu>
+ *          K.Prasad <prasad@linux.vnet.ibm.com>
+ *          Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index b6d6fa2..c166622 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -18,6 +18,10 @@
  * Copyright (C) 2009, Frederic Weisbecker <fweisbec@gmail.com>
  *
  * Thanks to Ingo Molnar for his many suggestions.
+ *
+ * Authors: Alan Stern <stern@rowland.harvard.edu>
+ *          K.Prasad <prasad@linux.vnet.ibm.com>
+ *          Frederic Weisbecker <fweisbec@gmail.com>
  */
 
 /*
diff --git a/samples/hw_breakpoint/data_breakpoint.c b/samples/hw_breakpoint/data_breakpoint.c
index 5bc9819..9506381 100644
--- a/samples/hw_breakpoint/data_breakpoint.c
+++ b/samples/hw_breakpoint/data_breakpoint.c
@@ -23,6 +23,8 @@
  * that variable.
  *
  * Copyright (C) IBM Corporation, 2009
+ *
+ * Author: K.Prasad <prasad@linux.vnet.ibm.com>
  */
 #include <linux/module.h>	/* Needed by all modules */
 #include <linux/kernel.h>	/* Needed for KERN_INFO */

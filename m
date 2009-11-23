Return-Path: <linux-kernel-owner+w=401wt.eu-S1755842AbZKWPrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842AbZKWPrS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 10:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755844AbZKWPrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 10:47:17 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:54555 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388AbZKWPrR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Nov 2009 10:47:17 -0500
Date: Mon, 23 Nov 2009 21:17:13 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [Patch 1/1] hw-breakpoint: Attribute authorship of hw-breakpoint
	related files
Message-ID: <20091123154713.GA5593@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,
	Please accept a patch (based on -tip tree) that attributes the
hw-breakpoint related files to the respective developers.

Thanks,
K.Prasad

Attribute authorship to developers of hw-breakpoint related files

Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
---
 arch/x86/kernel/hw_breakpoint.c         |    3 +++
 kernel/hw_breakpoint.c                  |    3 +++
 samples/hw_breakpoint/data_breakpoint.c |    3 +++
 3 files changed, 9 insertions(+)

Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
+++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
@@ -15,6 +15,9 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) 2009 IBM Corporation
+ *
+ * Author: Alan Stern <stern@rowland.harvard.edu>
+ *         K.Prasad <prasad@linux.vnet.ibm.com>
  */
 
 /*
Index: linux-2.6-tip/kernel/hw_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/kernel/hw_breakpoint.c
+++ linux-2.6-tip/kernel/hw_breakpoint.c
@@ -15,6 +15,9 @@
  *
  * Copyright (C) 2007 Alan Stern
  * Copyright (C) IBM Corporation, 2009
+ *
+ * Author: Alan Stern <stern@rowland.harvard.edu>
+ *         K.Prasad <prasad@linux.vnet.ibm.com>
  */
 
 /*
Index: linux-2.6-tip/samples/hw_breakpoint/data_breakpoint.c
===================================================================
--- linux-2.6-tip.orig/samples/hw_breakpoint/data_breakpoint.c
+++ linux-2.6-tip/samples/hw_breakpoint/data_breakpoint.c
@@ -23,6 +23,9 @@
  * that variable.
  *
  * Copyright (C) IBM Corporation, 2009
+ *
+ * Author: K.Prasad <prasad@linux.vnet.ibm.com>
+ *
  */
 #include <linux/module.h>	/* Needed by all modules */
 #include <linux/kernel.h>	/* Needed for KERN_INFO */

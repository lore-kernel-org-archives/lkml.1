Return-Path: <linux-kernel-owner+w=401wt.eu-S1752424AbYLSTDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbYLSTDR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 14:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750985AbYLSTDG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 14:03:06 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:47391 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946AbYLSTDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 14:03:05 -0500
Date: Fri, 19 Dec 2008 11:01:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] doc: reformat some long lines in kernel-parameters.txt
Message-Id: <20081219110152.e2cd14af.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.494BEFA3.0022:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Reformat text to (mostly) stay within 80 columns of text.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 Documentation/kernel-parameters.txt |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- linux-next-20081219.orig/Documentation/kernel-parameters.txt
+++ linux-next-20081219/Documentation/kernel-parameters.txt
@@ -1816,10 +1816,10 @@ and is between 256 and 4096 characters. 
 			autoconfiguration.
 			Ranges are in pairs (memory base and size).
 
-	dynamic_printk
-			Enables pr_debug()/dev_dbg() calls if
-			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled. These can also
-			be switched on/off via <debugfs>/dynamic_printk/modules
+	dynamic_printk	Enables pr_debug()/dev_dbg() calls if
+			CONFIG_DYNAMIC_PRINTK_DEBUG has been enabled.
+			These can also be switched on/off via
+			<debugfs>/dynamic_printk/modules
 
 	print-fatal-signals=
 			[KNL] debug: print fatal signals
@@ -1907,7 +1907,7 @@ and is between 256 and 4096 characters. 
 
 	reboot=		[BUGS=X86-32,BUGS=ARM,BUGS=IA-64] Rebooting mode
 			Format: <reboot_mode>[,<reboot_mode2>[,...]]
-			See arch/*/kernel/reboot.c or arch/*/kernel/process.c			
+			See arch/*/kernel/reboot.c or arch/*/kernel/process.c
 
 	relax_domain_level=
 			[KNL, SMP] Set scheduler's default relax_domain_level.
@@ -2481,8 +2481,8 @@ and is between 256 and 4096 characters. 
 			Format:
 			<irq>,<irq_mask>,<io>,<full_duplex>,<do_sound>,<lockup_hack>[,<irq2>[,<irq3>[,<irq4>]]]
 
-	norandmaps	Don't use address space randomization
-			Equivalent to echo 0 > /proc/sys/kernel/randomize_va_space
+	norandmaps	Don't use address space randomization.  Equivalent to
+			echo 0 > /proc/sys/kernel/randomize_va_space
 
 ______________________________________________________________________
 

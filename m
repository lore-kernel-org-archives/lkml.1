Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbYHVSob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbYHVSob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 14:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbYHVSoU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 14:44:20 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:3016 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751174AbYHVSoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 14:44:19 -0400
X-Greylist: delayed 762 seconds by postgrey-1.27 at vger.kernel.org; Fri, 22 Aug 2008 14:44:19 EDT
Date: Fri, 22 Aug 2008 20:31:28 +0200
From: Danny ter Haar <dth@cistron.nl>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Subject: [PATCH] trivial typo's 2.6.*
Message-ID: <20080822183128.GA23232@cistron.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Message-Flag: WARNING!! You are using MS (f)outlook: Please consider upgrading to software with less bugs.
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I noticed a typo during message on bootup.
Using grep found a few more.

Signed-off-by: Danny ter Haar <dth@cistron.nl>
Cc: trivial@kernel.org

--------------------------------------



diff -r -u linux-2.6.27-rc3-git6.orig/Documentation/cris/README linux-2.6.27-rc3-git6/Documentation/cris/README
--- linux-2.6.27-rc3-git6.orig/Documentation/cris/README	2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.27-rc3-git6/Documentation/cris/README	2008-08-19 16:04:20.876635000 +0200
@@ -27,7 +27,7 @@
 The ETRAX 100LX chip
 --------------------
 
-For reference, plase see the press-release:
+For reference, please see the press-release:
 
 http://www.axis.com/news/us/001101_etrax.htm
 
diff -r -u linux-2.6.27-rc3-git6.orig/Documentation/ia64/kvm.txt linux-2.6.27-rc3-git6/Documentation/ia64/kvm.txt
--- linux-2.6.27-rc3-git6.orig/Documentation/ia64/kvm.txt	2008-08-19 14:43:18.496631000 +0200
+++ linux-2.6.27-rc3-git6/Documentation/ia64/kvm.txt	2008-08-19 16:05:35.796644000 +0200
@@ -1,7 +1,8 @@
-Currently, kvm module in EXPERIMENTAL stage on IA64. This means that
-interfaces are not stable enough to use. So, plase had better don't run
-critical applications in virtual machine. We will try our best to make it
-strong in future versions!
+Currently, kvm module is in EXPERIMENTAL stage on IA64. This means that
+interfaces are not stable enough to use. So, please don't run critical 
+applications in virtual machine. 
+We will try our best to improve it in future versions!
+
 				Guide: How to boot up guests on kvm/ia64
 
 This guide is to describe how to enable kvm support for IA-64 systems.
diff -r -u linux-2.6.27-rc3-git6.orig/net/netfilter/nf_conntrack_acct.c linux-2.6.27-rc3-git6/net/netfilter/nf_conntrack_acct.c
--- linux-2.6.27-rc3-git6.orig/net/netfilter/nf_conntrack_acct.c	2008-08-19 14:46:12.906631000 +0200
+++ linux-2.6.27-rc3-git6/net/netfilter/nf_conntrack_acct.c	2008-08-22 20:19:43.976982594 +0200
@@ -69,7 +69,7 @@
 	int ret;
 
 #ifdef CONFIG_NF_CT_ACCT
-	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use\n");
+	printk(KERN_WARNING "CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use\n");
 	printk(KERN_WARNING "nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or\n");
 	printk(KERN_WARNING "sysctl net.netfilter.nf_conntrack_acct=1 to enable it.\n");
 #endif




-- 
The five R's of windows tech support: Retry, Reboot, Reinstall, Replace & Resign

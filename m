Return-Path: <linux-kernel-owner+w=401wt.eu-S1760770AbYDUTey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760770AbYDUTey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 15:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755737AbYDUTer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 15:34:47 -0400
Received: from vms044pub.verizon.net ([206.46.252.44]:57758 "EHLO
	vms044pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755501AbYDUTeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 15:34:46 -0400
Date: Mon, 21 Apr 2008 14:34:30 -0500
From: Corey Minyard <minyard@acm.org>
Subject: [PATCH 1/3] IPMI: Make comment match actual preprocessor check
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Reply-to: minyard@acm.org
Message-id: <20080421193430.GA13900@minyard.local>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Signed-off-by: Corey Minyard <cminyard@mvista.com>

Index: linux-2.6.24/include/linux/ipmi.h
===================================================================
--- linux-2.6.24.orig/include/linux/ipmi.h
+++ linux-2.6.24/include/linux/ipmi.h
@@ -64,7 +64,7 @@
  * applications and another for userland applications.  The
  * capabilities are basically the same for both interface, although
  * the interfaces are somewhat different.  The stuff in the
- * #ifdef KERNEL below is the in-kernel interface.  The userland
+ * #ifdef __KERNEL__ below is the in-kernel interface.  The userland
  * interface is defined later in the file.  */
 
 

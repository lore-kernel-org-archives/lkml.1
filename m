Return-Path: <linux-kernel-owner+w=401wt.eu-S965554AbXD3Kaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965554AbXD3Kaw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbXD3K3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:05 -0400
Received: from mx1.suse.de ([195.135.220.2]:51156 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbXD3K1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:45 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [1/40] x86_64: update MAINTAINERS
Message-Id: <20070430102733.B9603151CA@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:33 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 MAINTAINERS |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

===================================================================
Index: linux/MAINTAINERS
===================================================================
--- linux.orig/MAINTAINERS
+++ linux/MAINTAINERS
@@ -2616,6 +2616,19 @@ T:	git kernel.org:/pub/scm/linux/kernel/
 T:	cvs cvs.parisc-linux.org:/var/cvs/linux-2.6
 S:	Maintained
 
+PARAVIRT_OPS INTERFACE
+P:	Jeremy Fitzhardinge
+M:	jeremy@xensource.com
+P:	Chris Wright
+M:	chrisw@sous-sol.org
+P:	Zachary Amsden
+M:	zach@vmware.com
+P:	Rusty Russell
+M:	rusty@rustcorp.com.au
+L:	virtualization@lists.osdl.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+
 PC87360 HARDWARE MONITORING DRIVER
 P:	Jim Cromie
 M:	jim.cromie@gmail.com
@@ -3831,6 +3844,15 @@ M:	eis@baty.hanse.de
 L:	linux-x25@vger.kernel.org
 S:	Maintained
 
+XEN HYPERVISOR INTERFACE
+P:	Jeremy Fitzhardinge
+M:	jeremy@xensource.com
+P:	Chris Wright
+M:	chrisw@sous-sol.org
+L:	virtualization@lists.osdl.org
+L:	xen-devel@lists.xensource.com
+S:	Supported
+
 XFS FILESYSTEM
 P:	Silicon Graphics Inc
 P:	Tim Shimmin, David Chatterton

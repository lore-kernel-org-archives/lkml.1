Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbXDEAVL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbXDEAVL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:21:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932183AbXDEARq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:17:46 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36888 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932190AbXDEARB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:17:01 -0400
Message-Id: <20070404191204.683991792@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:11:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 01/20] update MAINTAINERS
Content-Disposition: inline; filename=add-MAINTAINERS.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Chris Wright <chrisw@sous-sol.org>
Cc: Zachary Amsden <zach@vmware.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
---
 MAINTAINERS |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

===================================================================
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -2583,6 +2583,19 @@ T:	cvs cvs.parisc-linux.org:/var/cvs/lin
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
@@ -3780,6 +3793,15 @@ L:	linux-x25@vger.kernel.org
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

-- 


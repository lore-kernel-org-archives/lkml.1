Return-Path: <linux-kernel-owner+w=401wt.eu-S1760896AbZDQAo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760896AbZDQAo6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 20:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760708AbZDQAkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 20:40:36 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:57923 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760656AbZDQAkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 20:40:35 -0400
Message-Id: <20090417001637.670524938@polymtl.ca>
References: <20090417001437.215128284@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 16 Apr 2009 20:14:38 -0400
From: mathieu.desnoyers@polymtl.ca
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [patch 1/3] rcupdate header remove whitespace
Content-Disposition: inline; filename=rcupdate-header-remove-whitespace.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 17 Apr 2009 00:38:23 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janitor-style whitespace cleanup. Will need to copy this header elsewhere
anyway.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux.trees.git/include/linux/rcupdate.h
===================================================================
--- linux.trees.git.orig/include/linux/rcupdate.h	2009-04-16 19:57:30.000000000 -0400
+++ linux.trees.git/include/linux/rcupdate.h	2009-04-16 19:57:35.000000000 -0400
@@ -18,7 +18,7 @@
  * Copyright IBM Corporation, 2001
  *
  * Author: Dipankar Sarma <dipankar@in.ibm.com>
- * 
+ *
  * Based on the original work by Paul McKenney <paulmck@us.ibm.com>
  * and inputs from Rusty Russell, Andrea Arcangeli and Andi Kleen.
  * Papers:

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

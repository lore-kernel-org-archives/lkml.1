Return-Path: <linux-kernel-owner+w=401wt.eu-S1756604AbZD2Xsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756604AbZD2Xsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 19:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753361AbZD2XsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 19:48:22 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:35393 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbZD2XsV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 19:48:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <18936.59200.888049.746658@cargo.ozlabs.ibm.com>
Date: Thu, 30 Apr 2009 09:48:16 +1000
From: Paul Mackerras <paulus@samba.org>
To: Ingo Molnar <mingo@elte.hu>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] perf_counter: update copyright notice
X-Mailer: VM 8.0.12 under 22.2.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds my name to the list of copyright holders on the core
perf_counter.c, since I have contributed a significant amount of the
code in there.

Signed-off-by: Paul Mackerras <paulus@samba.org>
---
Our lawyers say (C) doesn't mean anything, we have to use the actual
copyright symbol...

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a95a171..16c1f13 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -4,6 +4,7 @@
  *  Copyright (C) 2008 Thomas Gleixner <tglx@linutronix.de>
  *  Copyright (C) 2008-2009 Red Hat, Inc., Ingo Molnar
  *  Copyright (C) 2008-2009 Red Hat, Inc., Peter Zijlstra <pzijlstr@redhat.com>
+ *  Copyright  ©  2009 Paul Mackerras, IBM Corp. <paulus@au1.ibm.com>
  *
  *  For licensing details see kernel-base/COPYING
  */

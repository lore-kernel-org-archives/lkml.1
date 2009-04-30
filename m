Return-Path: <linux-kernel-owner+w=401wt.eu-S1753837AbZD3GZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbZD3GZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 02:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755240AbZD3GZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 02:25:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:54256 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756693AbZD3GZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 02:25:38 -0400
Date: Thu, 30 Apr 2009 06:24:55 GMT
From: tip-bot for Paul Mackerras <paulus@samba.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
       mingo@redhat.com, robert.richter@amd.com, a.p.zijlstra@chello.nl,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, robert.richter@amd.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <18936.59200.888049.746658@cargo.ozlabs.ibm.com>
References: <18936.59200.888049.746658@cargo.ozlabs.ibm.com>
Subject: [tip:perfcounters/core] perf_counter: update copyright notice
Message-ID: <tip-c5dd016cdf0a040e1de0b691e274fbfe642b2cdc@git.kernel.org>
Git-Commit-ID: c5dd016cdf0a040e1de0b691e274fbfe642b2cdc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 06:24:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c5dd016cdf0a040e1de0b691e274fbfe642b2cdc
Gitweb:     http://git.kernel.org/tip/c5dd016cdf0a040e1de0b691e274fbfe642b2cdc
Author:     Paul Mackerras <paulus@samba.org>
AuthorDate: Thu, 30 Apr 2009 09:48:16 +1000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 30 Apr 2009 08:23:11 +0200

perf_counter: update copyright notice

This adds my name to the list of copyright holders on the core
perf_counter.c, since I have contributed a significant amount of the
code in there.

Signed-off-by: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Robert Richter <robert.richter@amd.com>
LKML-Reference: <18936.59200.888049.746658@cargo.ozlabs.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/perf_counter.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index a95a171..75f2b6c 100644
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

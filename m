Return-Path: <linux-kernel-owner+w=401wt.eu-S1758878AbYHURST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878AbYHURST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 13:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753882AbYHURSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 13:18:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33694 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbYHURSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 13:18:05 -0400
Subject: 2.6.26.3-rt2
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 21 Aug 2008 13:18:02 -0400
Message-Id: <1219339082.22710.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26.3-rt2 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26-rt1

  - ported to 2.6.26.3

  - basic compile fixes (Steven Rostedt)

  - basic raw lock conversions (Steven Rostedt)

  - powerpc: irq radix tree updates (Sebastien Dugue)

  - call_rcu_sched (Paul E. McKenney)

  - rcu trace preemption fixes (Paul E. Mckenney)

  - remove lock in pm_qos_requirement (John Kacur)

  - rcu_process_callbacks (Paul E. McKenney)

  - rcu memory barriers update (Paul E. McKenney)

  - shorten posix_cpu_timers thread names (Arnaldo Carvalho de Melo)

  - account IRQ and RT load in SCHED_OTHER (Peter Zijlstra)

  - seq_lock updates/fixes (Gregory Haskins)

to build a 2.6.26.3-rt2 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.3.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.3-rt2.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve



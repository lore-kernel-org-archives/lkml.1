Return-Path: <linux-kernel-owner+w=401wt.eu-S1762706AbYFDT46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762706AbYFDT46 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 15:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759597AbYFDT4t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 15:56:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:62978 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759485AbYFDT4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 15:56:48 -0400
Subject: 2.6.25.4-rt5
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 04 Jun 2008 15:56:45 -0400
Message-Id: <1212609405.24785.32.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.25.4-rt5 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.25.4-rt4

  - Compile fixes for event tracer (Carsten Emde)

  - RW lock priority leak fix (Steven Rostedt)

  - RW lock pi_list management fixes (Steven Rostedt)

  - Event trace hook in clocksource (Steven Rostedt)

  - rwlock torture test module (Steven Rostedt)

  - trace_sched_wakeup __raw_spin_lock conversion (Steven Rostedt)

  - lockdep radix tree array plus 1 update (Steven Rostedt)

  - event trace NR_syscalls fix (sent by many, but was just a missing patch)

to build a 2.6.25.4-rt5 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
  http://rt.et.redhat.com/download/patch-2.6.25.4-rt5.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve



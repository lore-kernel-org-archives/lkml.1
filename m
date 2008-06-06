Return-Path: <linux-kernel-owner+w=401wt.eu-S1763387AbYFFDd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763387AbYFFDd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 23:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbYFFDdS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 23:33:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:50082 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbYFFDdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 23:33:18 -0400
Subject: 2.6.24.7-rt13
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Thu, 05 Jun 2008 23:33:15 -0400
Message-Id: <1212723195.24785.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt13 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt12

  - ftrace wakeup schedule raw spinlock (Steven Rostedt)

  - radix tree lockdep annotation fix (Steven Rostedt)

  - sched_cpupri hotplug support (Gregory Haskins)

  - sched_cpupri prio count (Gregory Haskins)

  - ftrace hotplug fix (Steven Rostedt)

to build a 2.6.24.7-rt13 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt13.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve




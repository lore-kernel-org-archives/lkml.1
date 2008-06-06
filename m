Return-Path: <linux-kernel-owner+w=401wt.eu-S1762232AbYFFW7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762232AbYFFW7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 18:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbYFFW7f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 18:59:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47546 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756829AbYFFW7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 18:59:33 -0400
Subject: 2.6.25.4-rt6
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Fri, 06 Jun 2008 18:59:31 -0400
Message-Id: <1212793171.7695.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.25.4-rt6 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.25.4-rt5

  - sched_cpupri hotplug support (Gregory Haskins)

  - sched_cpupri prio count (Gregory Haskins)

  - ftrace hotplug fix (Steven Rostedt)

to build a 2.6.25.4-rt6 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
  http://rt.et.redhat.com/download/patch-2.6.25.4-rt6.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve



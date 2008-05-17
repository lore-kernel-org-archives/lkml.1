Return-Path: <linux-kernel-owner+w=401wt.eu-S1758894AbYEQUHn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758894AbYEQUHn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 16:07:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758162AbYEQUHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 16:07:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:48466 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757859AbYEQUHc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 16:07:32 -0400
Subject: 2.6.25.4-rt1 (FINALLY!!!!)
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Content-Type: text/plain
Date: Sat, 17 May 2008 16:07:30 -0400
Message-Id: <1211054850.14697.16.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased (AT LAST!!!) to announce the 2.6.25.4-rt1 tree, which can
be downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt6

  - ported to 2.6.25.4

  - Updated ftrace to a (previously) recent version

  *** Kudos goes to Peter Zijlstra for getting the sched_rt groups and 
  *** sched_clock working again with -rt!!!!!!    

to build a 2.6.25.4-rt1 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.25.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.25.4.bz2
  http://rt.et.redhat.com/download/patch-2.6.25.4-rt1.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve

	


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbYJLTa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbYJLTa2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 15:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYJLTaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 15:30:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:50558 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYJLTaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 15:30:17 -0400
Subject: 2.6.26.6-rt10
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Sun, 12 Oct 2008 15:30:14 -0400
Message-Id: <1223839814.19319.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.26.6-rt10 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.26.5-rt9

  - ported to 2.6.26.6

  - rwlock to handle unnested order unlocks (Steven Rostedt)

  - rwlock update torture test to test unnested unlocks (Steven Rostedt)

  - remove rt push comment (Gregory Haskins)

  - rt sched fix to handle dequeue (Gregory Haskins)

  - PPC: remove duplicate stack trace code (Robert Schwebel)

  - ARM: ftrace event IRQ call fix (Alexander Pazdnikov)

  - fair sched not to resched RT tasks (Peter Zijlstra)

  - ftrace quick stop (Steven Rostedt)

  - event trace of resched (Steven Rostedt)


to build a 2.6.26.6-rt10 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.26.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.26.6.bz2
  http://rt.et.redhat.com/download/patch-2.6.26.6-rt10.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


-- Steve



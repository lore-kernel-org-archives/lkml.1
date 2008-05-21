Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbYEUEct@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbYEUEct (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 00:32:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751385AbYEUEck
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 00:32:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:55515 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbYEUEcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 00:32:39 -0400
Subject: 2.6.24.7-rt9
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain
Date: Wed, 21 May 2008 00:32:37 -0400
Message-Id: <1211344357.14697.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt9 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt8

  - RT downgrade_write (Steven Rostedt)

  - fix RT rwlocks typecasts (Steven Rostedt)

  - default sched_nr_migrate to 8 (Steven Rostedt)

  - ftrace task comm fix (Steven Rostedt)

  - ARM compile fix (Remy Bohmer)

to build a 2.6.24.7-rt9 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt9.bz2



And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.



-- Steve




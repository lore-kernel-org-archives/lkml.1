Return-Path: <linux-kernel-owner+w=401wt.eu-S1757394AbYJIDBH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394AbYJIDBH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 23:01:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754406AbYJIDAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 23:00:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:57436 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904AbYJIDAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 23:00:54 -0400
Subject: 2.6.24.7-rt21
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <srostedt@redhat.com>
Content-Type: text/plain
Date: Wed, 08 Oct 2008 23:00:51 -0400
Message-Id: <1223521251.12811.9.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the 2.6.24.7-rt21 tree, which can be
downloaded from the location:

  http://rt.et.redhat.com/download/

Information on the RT patch can be found at:

  http://rt.wiki.kernel.org/index.php/Main_Page

Changes since 2.6.24.7-rt20

  - back port of ftrace mcount record

  - Fix handling rwlocks unordered nesting

  - Updated rwlock torture test to test above fix

  - ftrace preempt tracer fix

to build a 2.6.24.7-rt21 tree, the following patches should be applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.24.tar.bz2
  http://kernel.org/pub/linux/kernel/v2.6/patch-2.6.24.7.bz2
  http://rt.et.redhat.com/download/patch-2.6.24.7-rt21.bz2


And like always, my RT version of Matt Mackall's ketchup will get this
for you nicely:

  http://people.redhat.com/srostedt/rt/tools/ketchup-0.9.8-rt3


The broken out patches are also available.


Note: A new 2.6.26-rt will soon follow.

-- Steve




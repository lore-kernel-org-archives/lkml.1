Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309Ab0BXQwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 11:52:46 -0500
Received: from www.tglx.de ([62.245.132.106]:39792 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756973Ab0BXQwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 11:52:44 -0500
Date: Wed, 24 Feb 2010 17:52:06 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>
Subject: [ANNOUNCE] 2.6.33-rc8-rt2
Message-ID: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

    - Update to linus latest

    - Fixes all over the place for the merge fallout

    - KVM fix from Jan

    - perf fix from Peter

    - tracer fixes from Carsten

Known issues:

    - the highmem problem which Fernando reported with i915 on 32bit
      i386 is not yet solved.

Download locations:
   
   http://www.kernel.org/pub/linux/kernel/projects/rt/

Git development branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/head

Git release branch:
   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git rt/2.6.33

Gitweb:
   http://git.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=shortlog;h=rt/2.6.33

Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page
 
To build the 2.6.33-rc8-rt2 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.32.tar.bz2
   http://www.kernel.org/pub/linux/kernel/v2.6/testing/patch-2.6.33-rc8.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rc8-rt2.bz2

Enjoy !

      tglx


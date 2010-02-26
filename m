Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965933Ab0BZTzK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 14:55:10 -0500
Received: from www.tglx.de ([62.245.132.106]:35906 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965897Ab0BZTzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 14:55:08 -0500
Date: Fri, 26 Feb 2010 20:54:25 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>, nando@ccrma.Stanford.EDU,
       Carsten Emde <ce@ceag.ch>
Subject: [ANNOUNCE] 2.6.33-rt3
In-Reply-To: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.1002262041020.4245@localhost.localdomain>
References: <alpine.LFD.2.00.1002241740410.4245@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series.

    - Update to 2.6.33

    - rt fixes:

      	 Peter Zijlstra (1):
    	       highmem, -rt: Implement pfn and prot kmaps

	Thomas Gleixner (2):
      	       x86: pci: Prevent mmconfig memory corruption
      	       mmc: omap_hsmmc: Fix the locking mess

A note on the development process:

  The rt/2.6.33 branch is now stabilization only. The rt/head branch
  will follow linus tree from now on, so it will inherit all
  (mis)features which come in the merge window.

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
 
To build the 2.6.33-rt3 tree, the following patches should be
applied:

   http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.33.tar.bz2
   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.33-rt3.bz2

Enjoy !

      tglx

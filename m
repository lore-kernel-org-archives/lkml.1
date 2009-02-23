Return-Path: <linux-kernel-owner+w=401wt.eu-S1757184AbZBWTpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757184AbZBWTpe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 14:45:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755064AbZBWTpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 14:45:24 -0500
Received: from www.tglx.de ([62.245.132.106]:48693 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754950AbZBWTpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 14:45:23 -0500
Date: Mon, 23 Feb 2009 20:44:40 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
cc: rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>
Subject: [Announce] 2.6.29-rc6-rt2
In-Reply-To: <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain> <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are pleased to announce the next update to our new preempt-rt
series. It forwards to 2.6.29-rc6 and fixes

	- various 32bit highmem related problems
	- paravirt interaction
	- sg list warnings
	- IPI updates
	 
Download locations:
 
    http://rt.et.redhat.com/download/
    http://www.kernel.org/pub/linux/kernel/projects/rt/
  
Information on the RT patch can be found at:

   http://rt.wiki.kernel.org/index.php/Main_Page

to build the 2.6.29-rc6-rt2 tree, the following patches should be
applied:

  http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc6.tar.bz2
  http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc6-rt2.bz2
 
The broken out patches are also available at the same download
locations.

Enjoy !

      Thomas, Ingo

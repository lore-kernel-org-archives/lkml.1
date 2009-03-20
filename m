Return-Path: <linux-kernel-owner+w=401wt.eu-S1757037AbZCTVjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757037AbZCTVjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 17:39:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751880AbZCTVji
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 17:39:38 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37518 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZCTVji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 17:39:38 -0400
Date: Fri, 20 Mar 2009 14:39:35 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, laijs@cn.fujitsu.com
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090320213935.GL6698@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090319073357.GA14615@elte.hu> <alpine.DEB.2.00.0903191309170.16987@gandalf.stny.rr.com> <20090320174331.GH6698@linux.vnet.ibm.com> <20090320183642.GA2070@elte.hu> <20090320183849.GA3657@elte.hu> <20090320191926.GJ6698@linux.vnet.ibm.com> <20090320192721.GI6224@elte.hu> <20090320194617.GA5934@nowhere> <20090320195414.GA24129@elte.hu> <20090320204848.GA6044@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320204848.GA6044@nowhere>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 09:48:48PM +0100, Frederic Weisbecker wrote:
> On Fri, Mar 20, 2009 at 08:54:14PM +0100, Ingo Molnar wrote:
> > * Frederic Weisbecker <fweisbec@gmail.com> wrote:

[ . . . ]

> > i dont have a reproducer right now. Can you trigger it with latest 
> > -tip, which has this commit included:
> > 
> > 04cb9ac: rcu: rcu_barrier VS cpu_hotplug: Ensure callbacks in dead cpu are migrated to o
> > 
> > ?
> > 
> > 	Ingo
> 
> 
> I tested three times the same things but with 04cb9ac and... it didn't triggered
> anymore :-)

Woo-hoo!!!  ;-)

							Thanx, Paul

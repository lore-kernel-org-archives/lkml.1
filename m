Return-Path: <linux-kernel-owner+w=401wt.eu-S1750708AbXDOGnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750708AbXDOGnL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 02:43:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbXDOGnL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 02:43:11 -0400
Received: from mail.gmx.net ([213.165.64.20]:44409 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750708AbXDOGnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 02:43:10 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19qku0ai6xqbi+NySL14+TWmRwwk+81WCyqlR7OEd
	bYoZrKsdEUk0HB
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
	Scheduler [CFS]
From: Mike Galbraith <efault@gmx.de>
To: Con Kolivas <kernel@kolivas.org>
Cc: Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <200704151327.13589.kernel@kolivas.org>
References: <20070413202100.GA9957@elte.hu>
	 <200704151327.13589.kernel@kolivas.org>
Content-Type: text/plain
Date: Sun, 15 Apr 2007 08:43:04 +0200
Message-Id: <1176619384.6222.70.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-04-15 at 13:27 +1000, Con Kolivas wrote:
> On Saturday 14 April 2007 06:21, Ingo Molnar wrote:
> > [announce] [patch] Modular Scheduler Core and Completely Fair Scheduler
> > [CFS]
> >
> > i'm pleased to announce the first release of the "Modular Scheduler Core
> > and Completely Fair Scheduler [CFS]" patchset:
> >
> >    http://redhat.com/~mingo/cfs-scheduler/sched-modular+cfs.patch
> >
> > This project is a complete rewrite of the Linux task scheduler. My goal
> > is to address various feature requests and to fix deficiencies in the
> > vanilla scheduler that were suggested/found in the past few years, both
> > for desktop scheduling and for server scheduling workloads.
> 
> The casual observer will be completely confused by what on earth has happened 
> here so let me try to demystify things for them.

[...]

Demystify what?   The casual observer need only read either your attempt
at writing a scheduler, or my attempts at fixing the one we have, to see
that it was high time for someone with the necessary skills to step in.
Now progress can happen, which was _not_ happening before.

	-Mike


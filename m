Return-Path: <linux-kernel-owner+w=401wt.eu-S965461AbXDNSsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965461AbXDNSsz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 14:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965528AbXDNSsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 14:48:55 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:52005
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965461AbXDNSsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 14:48:54 -0400
Date: Sat, 14 Apr 2007 11:48:38 -0700
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070414184838.GB17993@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu> <20070413223131.GA1642@1wt.eu> <20070413231809.GA15894@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070413231809.GA15894@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2007 at 01:18:09AM +0200, Ingo Molnar wrote:
> very much so! Both Con and Mike has contributed regularly to upstream 
> sched.c:

The problem here is tha Con can get demotivated (and rather upset) when an
idea gets proposed, like SchedPlug, only to have people be hostile to it
and then sudden turn around an adopt this idea. It give the impression
that you, in this specific case, were more interested in controlling a
situation and the track of development instead of actually being inclusive
of the development process with discussion and serious consideration, etc...

This is how the Linux community can be perceived as elitist. The old guard
would serve the community better if people were more mindful and sensitive
to developer issues. There was a particular speech that I was turned off by
at OLS 2006 that pretty much pandering to the "old guard's" needs over
newer developers. Since I'm a some what established engineer in -rt (being
the only other person that mapped the lock hierarchy out for full
preemptibility), I had the confidence to pretty much ignored it while
previously this could have really upset me and be highly discouraging to
a relatively new developer.

As Linux gets larger and larger this is going to be an increasing problem
when folks come into the community with new ideas and the community will
need to change if it intends to integrate these folks. IMO, a lot of
these flame ware wouldn't need to exist if folks listent ot each other
better and permit co-ownership of code like the scheduler since it needs
multipule hands in it adapt to new loads and situations, etc...

I'm saying this nicely now since I can be nasty about it.

bill


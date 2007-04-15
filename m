Return-Path: <linux-kernel-owner+w=401wt.eu-S1752413AbXDOIgl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413AbXDOIgl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 04:36:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752414AbXDOIgl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 04:36:41 -0400
Received: from adsl-69-232-92-238.dsl.sndg02.pacbell.net ([69.232.92.238]:50224
	"EHLO gnuppy.monkey.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbXDOIgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 04:36:40 -0400
Date: Sun, 15 Apr 2007 01:36:16 -0700
To: Mike Galbraith <efault@gmx.de>
Cc: Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       "Bill Huey (hui)" <billh@gnuppy.monkey.org>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415083616.GA29878@gnuppy.monkey.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176619384.6222.70.camel@Homer.simpson.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Bill Huey (hui) <billh@gnuppy.monkey.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 08:43:04AM +0200, Mike Galbraith wrote:
> [...]
> 
> Demystify what?   The casual observer need only read either your attempt

Here's the problem. You're a casual observer and obviously not paying
attention.

> at writing a scheduler, or my attempts at fixing the one we have, to see
> that it was high time for someone with the necessary skills to step in.
> Now progress can happen, which was _not_ happening before.

I think that's inaccurate and there are plenty of folks that have that
technical skill and background. The scheduler code isn't a deep mystery
and there are plenty of good kernel hackers out here across many
communities.  Ingo isn't the only person on this planet to have deep
scheduler knowledge. Priority heaps are not new and Solaris has had a
pluggable scheduler framework for years.

Con's characterization is something that I'm more prone to believe about
how Linux kernel development works versus your view. I think it's a great
shame to have folks like Bill Irwin and Con to have waste time trying to
do something right only to have their ideas attack, then copied and held
as the solution for this kind of technical problem as complete reversal
of technical opinion as it suits a moment. This is just wrong in so many
ways.

It outlines the problems with Linux kernel development and questionable
elistism regarding ownership of certain sections of the kernel code.

I call it "churn squat" and instances like this only support that view
which I would rather it be completely wrong and inaccurate instead.

bill


Return-Path: <linux-kernel-owner+w=401wt.eu-S936713AbXGTXYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936713AbXGTXYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 19:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758934AbXGTXYf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 19:24:35 -0400
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:52582 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210AbXGTXYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 19:24:34 -0400
Date: Fri, 20 Jul 2007 19:23:38 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Arjan van de Ven <arjan@linux.intel.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [RFC, Announce] Unified x86 architecture, arch/x86
In-Reply-To: <1184972499.2692.9.camel@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.58.0707201922210.21951@gandalf.stny.rr.com>
References: <1184970779.4012.38.camel@chaos> <1184972499.2692.9.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 20 Jul 2007, Arjan van de Ven wrote:

> On Sat, 2007-07-21 at 00:32 +0200, Thomas Gleixner wrote:
> > We are pleased to announce a project we've been working on for some
> > time: the unified x86 architecture tree, or "arch/x86" - and we'd like
> > to solicit feedback about it.
>
>
>
> I really like the idea of a unified source tree for the 2 x86 variants.
> The technical differences are really small (of course there are
> differences, especially in the boot sequence), and striving to unify as
> much as possible while having a clean way to do per 32/64 bit parts as
> well is something that imo is the right thing.
>

Not to mention all the paravirt stuff that's going on. Having a single
x86 arch to work with would be greatly beneficial to the work being done
to port paravirt to x86_64.

Way to go, Thomas and Ingo!

-- Steve


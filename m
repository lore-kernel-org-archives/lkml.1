Return-Path: <linux-kernel-owner+w=401wt.eu-S1751894AbXDOSAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751894AbXDOSAq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 14:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753255AbXDOSAq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 14:00:46 -0400
Received: from smtp.osdl.org ([65.172.181.24]:59959 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894AbXDOSAp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 14:00:45 -0400
Date: Sun, 15 Apr 2007 10:59:54 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <efault@gmx.de>
cc: Pekka J Enberg <penberg@cs.helsinki.fi>, Willy Tarreau <w@1wt.eu>,
       hui Bill Huey <billh@gnuppy.monkey.org>, Ingo Molnar <mingo@elte.hu>,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <1176658335.6364.11.camel@Homer.simpson.net>
Message-ID: <Pine.LNX.4.64.0704151054080.5473@woody.linux-foundation.org>
References: <20070413202100.GA9957@elte.hu>  <200704151327.13589.kernel@kolivas.org>
  <20070415051645.GA28438@gnuppy.monkey.org> <20070415084447.GC24886@elte.hu>
  <20070415095146.GA30327@gnuppy.monkey.org> 
 <84144f020704150339i4a0d437fja6868ab671558ba1@mail.gmail.com> 
 <20070415124527.GP943@1wt.eu>  <Pine.LNX.4.64.0704151604520.7215@sbz-30.cs.Helsinki.FI>
 <1176658335.6364.11.camel@Homer.simpson.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 15 Apr 2007, Mike Galbraith wrote:

> On Sun, 2007-04-15 at 16:08 +0300, Pekka J Enberg wrote:
> > 
> > He did exactly that and he did it with a patch. Nothing new here. This is 
> > how development on LKML proceeds when you have two or more competing 
> > designs. There's absolutely no need to get upset or hurt your feelings 
> > over it. It's not malicious, it's how we do Linux development.
> 
> Yes.  Exactly.  This is what it's all about, this is what makes it work.

I obviously agree, but I will also add that one of the most motivating 
things there *is* in open source is "personal pride".

It's a really good thing, and it means that if somebody shows that your 
code is flawed in some way (by, for example, making a patch that people 
claim gets better behaviour or numbers), any *good* programmer that 
actually cares about his code will obviously suddenly be very motivated to 
out-do the out-doer!

Does this mean that there will be tension and rivalry? Hell yes. But 
that's kind of the point. Life is a game, and if you aren't in it to win, 
what the heck are you still doing here?

As long as it's reasonably civil (I'm not personally a huge believer in 
being too polite or "politically correct", so I think the "reasonably" is 
more important than the "civil" part!), and as long as the end result is 
judged on TECHNICAL MERIT, it's all good.

We don't want to play politics. But encouraging peoples competitive 
feelings? Oh, yes. 

			Linus

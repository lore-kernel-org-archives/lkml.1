Return-Path: <linux-kernel-owner+w=401wt.eu-S1752941AbYJBTYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbYJBTYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 15:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbYJBTYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 15:24:03 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:37203 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbYJBTYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 15:24:02 -0400
Date: Thu, 2 Oct 2008 15:23:59 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Daniel Walker <dwalker@mvista.com>
cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Veen <arjan@infradead.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
Subject: Re: [RFC patch 0/5] genirq: add infrastructure for threaded interrupt
 handlers
In-Reply-To: <1222974254.2995.144.camel@laptop-eth>
Message-ID: <alpine.DEB.1.10.0810021520560.2919@gandalf.stny.rr.com>
References: <20081001223213.078984344@linutronix.de>  <1222912413.2995.80.camel@laptop-eth.lan>  <alpine.DEB.1.10.0810021052010.19018@gandalf.stny.rr.com>  <1222962525.2995.100.camel@laptop-eth>  <alpine.LFD.1.10.0810022004520.5549@apollo.tec.linutronix.de>
 <1222974254.2995.144.camel@laptop-eth>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2 Oct 2008, Daniel Walker wrote:

> On Thu, 2008-10-02 at 20:42 +0200, Thomas Gleixner wrote:
> 
> > Clearly you have neither clue about real time nor about operating
> > systems in general. 
> 
> Here we go again Thomas.. You think you can have a conversation without
> the insults for once?
> 
> > Solaris, some BSDs and MacOSX use interrupt threads. Where exactly is
> > the relation to realtime?
> 
> The very fact that you mention it in your release notes .. You mention
> the type of system in "preempt-rt" and the advantage of your system..
> 
> > The concept of interrupt threads is nothing which is in any way
> > related to real time. It is a well known and pretty old concept in
> > operating system design.
> > 
> > The fact that real time operating systems benefit from interrupt
> > threads is a totally different topic.
> > 
> 
> The fact that a direct relationship exists means that any threaded
> interrupt system needs to take into account the inevitable connection to
> real time since it will be used in that system as a core component.. If
> you can't effectively achieve real time with your system , than that's a
> problem that needs to be addressed. 

Daniel, what kind of logic is this? I was already accused of being on 
crack today (but was just too much coffee). Perhaps you might be the one 
that's on crack.

I build a pipe. There exists a relationship between a pipe and crap 
running through it from my toilet. Does this mean that every time I need a 
pipe, that I need to take into account the inevitable connection to crap 
to run through it?

God, I can see the problems with my gas lines.

-- Steve


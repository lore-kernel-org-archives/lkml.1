Return-Path: <linux-kernel-owner+w=401wt.eu-S1760207AbYEFIV3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760207AbYEFIV3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:21:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYEFIVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:21:12 -0400
Received: from www.tglx.de ([62.245.132.106]:50262 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230AbYEFIVJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:21:09 -0400
Date: Tue, 6 May 2008 10:19:22 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Daniel Walker <dwalker@mvista.com>
cc: Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Preempt-RT patch for 2.6.25
In-Reply-To: <1210039855.17132.105.camel@localhost.localdomain>
Message-ID: <alpine.LFD.1.10.0805060908050.3318@apollo.tec.linutronix.de>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>  <1209753250.25628.34.camel@dd.thebigcorporation.com>  <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>  <1209754467.25628.42.camel@dd.thebigcorporation.com> 
 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>  <1210003265.17132.6.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>  <1210004376.17132.14.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
  <1210007084.17132.32.camel@localhost.localdomain>  <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>  <1210013938.17132.55.camel@localhost.localdomain>  <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>  <1210025532.17132.82.camel@localhost.localdomain>
  <alpine.LFD.1.10.0805060334220.3318@apollo.tec.linutronix.de> <1210039855.17132.105.camel@localhost.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 May 2008, Daniel Walker wrote:
> On Tue, 2008-05-06 at 03:54 +0200, Thomas Gleixner wrote:
> > On Mon, 5 May 2008, Daniel Walker wrote:
> > > On Mon, 2008-05-05 at 23:01 +0200, Thomas Gleixner wrote:
> > > > We have been there before. kernel development does not follow the "we
> > > > want _now_" principle at all. Have you ever tried to yell at Linus "we
> > > > want XYZ _now_" ? If you decide to try it, please keep me on CC - I
> > > > want to enjoy the show.
> > > 
> > > Kernel development is "What is available now?" not what is avaiable in
> > > the future.
> > > 
> > > If you want to reject code you better have a reason other than "We're
> > > going to make some new code for that (some time in the future) sorry."
> > 
> > You miss the point. We reject code which breaks existing functionality.
> 
> This point , to me, isn't valid. Even if you think it is, the point was
> brought up just recently, after Steven finish port to 2.6.25.

Even if you don't care to put me on CC I pretty much follow the
mailing list. All I can see is your priggish "release" message, but no
sign of prior discussion on how to approach that problem.

> So assuming you think bisection is good, and you think the architectures
> should have been included then we should have discussed it a long time
> ago when my code was first release.

You have "released" code and trees before which were ignored. All for
the same reason: your unwillingness to cooperate.

You create some "works for me" artifact, "release" it pompously and
expect that it is picked up and the work you were not willing to do is
finished by others. If that's not happening then you waste everyones
valuable time with your brashly impertinent and stubborn requests to
enforce your POV on those who have developed and maintained preempt-rt
for years.

If that is your idea of cooperation then please look for a community
and maintainers who are willing to accept that mode of operation.

Thanks,

	tglx

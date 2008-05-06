Return-Path: <linux-kernel-owner+w=401wt.eu-S1764058AbYEFCLS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764058AbYEFCLS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 22:11:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757933AbYEFCK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 22:10:58 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:58181 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757557AbYEFCK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 22:10:57 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <alpine.LFD.1.10.0805060334220.3318@apollo.tec.linutronix.de>
References: <3efb10970805021102n4d87f55eue723786281b06fcb@mail.gmail.com>
	 <1209753250.25628.34.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021441340.10615@gandalf.stny.rr.com>
	 <1209754467.25628.42.camel@dd.thebigcorporation.com>
	 <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
	 <1210003265.17132.6.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
	 <1210004376.17132.14.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
	 <1210007084.17132.32.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
	 <1210013938.17132.55.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
	 <1210025532.17132.82.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805060334220.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 05 May 2008 19:10:55 -0700
Message-Id: <1210039855.17132.105.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 03:54 +0200, Thomas Gleixner wrote:
> On Mon, 5 May 2008, Daniel Walker wrote:
> > On Mon, 2008-05-05 at 23:01 +0200, Thomas Gleixner wrote:
> > > We have been there before. kernel development does not follow the "we
> > > want _now_" principle at all. Have you ever tried to yell at Linus "we
> > > want XYZ _now_" ? If you decide to try it, please keep me on CC - I
> > > want to enjoy the show.
> > 
> > Kernel development is "What is available now?" not what is avaiable in
> > the future.
> > 
> > If you want to reject code you better have a reason other than "We're
> > going to make some new code for that (some time in the future) sorry."
> 
> You miss the point. We reject code which breaks existing functionality.

This point , to me, isn't valid. Even if you think it is, the point was
brought up just recently, after Steven finish port to 2.6.25.

So assuming you think bisection is good, and you think the architectures
should have been included then we should have discussed it a long time
ago when my code was first release.

It's not like -rt is overflowing with patches to evaluate.

Daniel


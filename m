Return-Path: <linux-kernel-owner+w=401wt.eu-S1760288AbYEFBnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760288AbYEFBnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 21:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756686AbYEFBnK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 21:43:10 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:54209 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbYEFBnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 21:43:08 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <alpine.LFD.1.10.0805060258360.3318@apollo.tec.linutronix.de>
References: <Pine.LNX.4.58.0805021502040.10615@gandalf.stny.rr.com>
	 <1210003265.17132.6.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
	 <1210004376.17132.14.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
	 <1210007084.17132.32.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
	 <1210013938.17132.55.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
	 <1210025532.17132.82.camel@localhost.localdomain>
	 <20080505234743.GA11433@elte.hu>
	 <1210032701.17132.98.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805060258360.3318@apollo.tec.linutronix.de>
Content-Type: text/plain
Date: Mon, 05 May 2008 18:43:04 -0700
Message-Id: <1210038184.17132.100.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 03:30 +0200, Thomas Gleixner wrote:
> On Mon, 5 May 2008, Daniel Walker wrote:
> > On Tue, 2008-05-06 at 01:47 +0200, Ingo Molnar wrote:
> > > * Daniel Walker <dwalker@mvista.com> wrote:
> > > 
> > > > I think dropping ports (temporarily) is perfectly reasonable. There is 
> > > > no reason to hamper forward development just to keep old architecture 
> > > > ports in the tree.
> > > 
> > > You are missing the point: a lot of people (those who wrote the brunt of 
> > > the -rt tree and who maintained it over the years and who maintain it 
> > > today) think it's not reasonable and have stated it very clearly to you 
> > > that it's a bug. Keeping things alive is not preventing forward 
> > > development.
> > 
> > That has always been my intention. I've never said the arch code would
> > be permanently gone. 
> 
> Get it. Dropping it means bitrot.
> 
> The responsible maintainers keep that (maybe stale) code at least in
> sync as far as the obvious fixups are concerned.
> 
> Your way of chosing the least effort approach and justifying it with
> handwaving arguments is just disgusting.

Can you stop with these comments. Lets try to resolve this in civil way.

Daniel


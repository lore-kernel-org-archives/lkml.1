Return-Path: <linux-kernel-owner+w=401wt.eu-S1764959AbYEFQB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764959AbYEFQB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:01:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764319AbYEFQBI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:01:08 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59410 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756384AbYEFQBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:01:06 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
In-Reply-To: <20080506084338.GA19151@elte.hu>
References: <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com>
	 <1210004376.17132.14.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com>
	 <1210007084.17132.32.camel@localhost.localdomain>
	 <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com>
	 <1210013938.17132.55.camel@localhost.localdomain>
	 <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de>
	 <1210025532.17132.82.camel@localhost.localdomain>
	 <20080505234743.GA11433@elte.hu>
	 <1210032701.17132.98.camel@localhost.localdomain>
	 <20080506084338.GA19151@elte.hu>
Content-Type: text/plain
Date: Tue, 06 May 2008 09:01:03 -0700
Message-Id: <1210089663.17132.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 10:43 +0200, Ingo Molnar wrote:
> * Daniel Walker <dwalker@mvista.com> wrote:
> 
> > > Since it's code that you regard stale it shouldnt be all that hard 
> > > to fix it up - in general it's much easier to fix a bug than to talk 
> > > it out of existence, even if you disagree with a maintainer about 
> > > how significant a bug is.
> > 
> > It shouldn't be hard, but it's too much to do all in one go. [...]
> 
> this sort of "it was too hard for me but I expect the maintainers to 
> clean up the mess" stance, combined with an aggressive, uncompromising, 
> demanding tone towards the maintainers of a project wont get you very 
> far in contributing to any open-source project. You are not their boss, 
> you have to learn to work with them instead of trying to force your 
> opinion on them. They clearly try to work with you and gave a 
> straightforward technical description of how your contribution would be 
> acceptable to the project. All the rest is just a waste of everyone's 
> time that could be better spent on improving the project. JFYI.

It's not "too hard for me" it's a matter of correctness. As if I would
ever say that Ingo ..

I'm not forcing my opinion on anyone. I'm assuming cleanup are
acceptable, especially bisect cleanup (when your code isn't bisectable).
My position is based on that.

You release a dirty -rt tree and expect no one will clean it up, and
further more if they do clean up your code you just toss the work aside
like it's pointless. I take it you don't want clean ups. From my
perspective you should be thanking me.

Had Steven simple said "Please include all the architecture" a month ago
when I released my code, I may have actually done that.

This thread is in no way a plea to get my code included. My code never
had a chance to be included anyway ..

Daniel


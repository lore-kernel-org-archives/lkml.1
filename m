Return-Path: <linux-kernel-owner+w=401wt.eu-S1760293AbYEFIoS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760293AbYEFIoS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 04:44:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755729AbYEFIoA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 04:44:00 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:33717 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755464AbYEFIn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 04:43:59 -0400
Date: Tue, 6 May 2008 10:43:38 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <rostedt@goodmis.org>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: Preempt-RT patch for 2.6.25
Message-ID: <20080506084338.GA19151@elte.hu>
References: <Pine.LNX.4.58.0805051210410.23084@gandalf.stny.rr.com> <1210004376.17132.14.camel@localhost.localdomain> <Pine.LNX.4.58.0805051240520.25250@gandalf.stny.rr.com> <1210007084.17132.32.camel@localhost.localdomain> <Pine.LNX.4.58.0805051426010.25250@gandalf.stny.rr.com> <1210013938.17132.55.camel@localhost.localdomain> <alpine.LFD.1.10.0805052107270.3318@apollo.tec.linutronix.de> <1210025532.17132.82.camel@localhost.localdomain> <20080505234743.GA11433@elte.hu> <1210032701.17132.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1210032701.17132.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > Since it's code that you regard stale it shouldnt be all that hard 
> > to fix it up - in general it's much easier to fix a bug than to talk 
> > it out of existence, even if you disagree with a maintainer about 
> > how significant a bug is.
> 
> It shouldn't be hard, but it's too much to do all in one go. [...]

this sort of "it was too hard for me but I expect the maintainers to 
clean up the mess" stance, combined with an aggressive, uncompromising, 
demanding tone towards the maintainers of a project wont get you very 
far in contributing to any open-source project. You are not their boss, 
you have to learn to work with them instead of trying to force your 
opinion on them. They clearly try to work with you and gave a 
straightforward technical description of how your contribution would be 
acceptable to the project. All the rest is just a waste of everyone's 
time that could be better spent on improving the project. JFYI.

	Ingo

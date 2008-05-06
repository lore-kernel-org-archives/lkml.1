Return-Path: <linux-kernel-owner+w=401wt.eu-S932409AbYEFQIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbYEFQIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 12:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765249AbYEFQF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 12:05:29 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:61637 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765235AbYEFQF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 12:05:27 -0400
Subject: Re: Preempt-RT patch for 2.6.25
From: Daniel Walker <dwalker@mvista.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Remy Bohmer <linux@bohmer.net>, LKML <linux-kernel@vger.kernel.org>,
       RT <linux-rt-users@vger.kernel.org>,
       Jon Masters <jonathan@jonmasters.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <Pine.LNX.4.58.0805060634330.12081@gandalf.stny.rr.com>
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
	 <Pine.LNX.4.58.0805060634330.12081@gandalf.stny.rr.com>
Content-Type: text/plain
Date: Tue, 06 May 2008 09:05:22 -0700
Message-Id: <1210089922.17132.132.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-3.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-05-06 at 06:40 -0400, Steven Rostedt wrote:
> Dropping someones work from the official tree is an insult to the
> developer that did that work. The *only* reason to drop code is if it
> happens to break something else that already existed or it has been warned
> for at least one year that if no one maintains this code it will be
> dropped. Dropping it for the sake of making "my work easier" is not an
> excuse.
> 
> Don't say "well it's only temporary" because it's not. You even expected
> the ones that did the work to "re-port" it to your new tree. Sorry Daniel,
> that's not the way things happen in Open Source.

Steven, this is all out of mainline. It works however we want it to
work.

As I've been saying, had you wanted the architectures included, you
should have said that a month ago. You had a month you review everything
and work with me ..

Daniel


Return-Path: <linux-kernel-owner+w=401wt.eu-S1758543AbXJOVpx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543AbXJOVpx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 17:45:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751722AbXJOVpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 17:45:44 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:9637 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667AbXJOVpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 17:45:43 -0400
Subject: Re: [PATCH] RT: fix spin_trylock_irq
From: Daniel Walker <dwalker@mvista.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       =?ISO-8859-1?Q?S=E9bastien_Dugu=E9?= <sebastien.dugue@bull.net>,
       Ingo Molnar <mingo@elte.hu>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.0.9999.0710152308220.22612@localhost.localdomain>
References: <20071011142417.1d965820@bull.net>
	 <Pine.LNX.4.58.0710111046170.20114@gandalf.stny.rr.com>
	 <1192470246.17527.15.camel@imap.mvista.com>
	 <Pine.LNX.4.58.0710151406230.26495@gandalf.stny.rr.com>
	 <1192478816.17527.58.camel@imap.mvista.com>
	 <alpine.LFD.0.9999.0710152308220.22612@localhost.localdomain>
Content-Type: text/plain
Date: Mon, 15 Oct 2007 14:44:10 -0700
Message-Id: <1192484650.17527.76.camel@imap.mvista.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-10-15 at 23:35 +0200, Thomas Gleixner wrote:
> On Mon, 15 Oct 2007, Daniel Walker wrote:
> > On Mon, 2007-10-15 at 14:14 -0400, Steven Rostedt wrote:
> > 
> > > > This is the second fix for this .. The first was in this email (over a
> > > > month ago)
> > > >
> > > > http://lkml.org/lkml/2007/8/31/318
> > > 
> > > You're right I missed that. (I even read it). But for fixes like this, (or
> > > any patches that are not in the tree), you really need to resend the
> > > series.
> > 
> > In hindsight I should have resent, but I didn't .. Really it's a matter
> > of frustration on my part. Where I submit patches that should be
> > included , but they are ignored for no clear reason .. Then I submit
> > again, and the patches are ignored again for no clear reason..
> 
> You were asked to rebase your patches against the latest -rt
> kernel. And you bluntly refused to.

Nope , I did rebase my patches when Steven asked me to ..

> I knew exactly why I ignored the patches when I was moving -rt
> forward. Simply because I had not enough time to review them in
> detail. Ingo acked them in principle, but we had subtle wreckage from
> such changes before and I had no intention to put more risk into a non
> trivial merge.
> 
> Sorry, you have provided sloppy patches more than once and requested
> us to pick random bugfixes from a broken ftp server or from the
> mailing list. It's you who wrote the track record, not us.

Oh boy here we go again .. Let just stop right here..

> I'm finally fed up with your prima ballerina attitudes. Either you
> want to be part of this project or not. If yes, then please accept
> that you are not setting the rules how this works. If no, please stop
> whining at us and look for a nice sandpit where you can play these
> silly games.
>  
> 	tglx


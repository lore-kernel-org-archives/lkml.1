Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbXFOVx7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbXFOVx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 17:53:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759383AbXFOVxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 17:53:46 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53920 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759331AbXFOVxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 17:53:44 -0400
Date: Fri, 15 Jun 2007 14:52:31 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Daniel Hazelton <dhazelton@enter.net>
cc: Alexandre Oliva <aoliva@redhat.com>, Jesper Juhl <jesper.juhl@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Friesen <cfriesen@nortel.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, debian developer <debiandev@gmail.com>,
       david@lang.hm, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <200706151715.55218.dhazelton@enter.net>
Message-ID: <alpine.LFD.0.98.0706151427130.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <200706150308.20148.dhazelton@enter.net>
 <or1wgd102n.fsf@oliva.athome.lsd.ic.unicamp.br>
 <200706151715.55218.dhazelton@enter.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Daniel Hazelton wrote:
> 
> And the preamble, not being part of the active portion of the license, has 
> absolutely *ZERO* bearing.

That's not true. Again, ianal, etc etc, but:

"Intent" *does* matter, and if you wrote down the intent at the time you 
entered some legal agreement, that actually also has non-zero bearing (as 
it can be used to _show_ intent more clearly than claiming fifteen years 
later "but, your honour, I _intended_ to do something else").

BUT!

Intent only matters if the contract reading itself isn't otherwise clear!

In other words, intent can never *override* the contract. But if there is 
some actual legally unclear area, the intent can be used by a 
judge/jury/arbitrator to _guide_ them to the decision. And the better 
documented that intent is, the better it is in that respect. Intent 
_after_ the fact is not very meaningful, is it?

So the preamble *does* matter legally, it just matters a lot less than the 
actual legal wording itself.

Put another way: the "intent" of the parties can be, and is, used to read 
the contract, but it's actually a mutual thing for a contract (since you 
have two or more parties in question - the intent of _one_ party doesn't 
really matter, if he cannot show that the other party agreed with that 
intent! And to get back to rms' personal history: _his_ intent, and _his_ 
personal history, and _his_ other documents don't matter for an 
agreement that doesn't include him).

So as such, a preamble can be used to show the intent of the parties, and 
thus to guide any reading.

Of course, so can "real life". If a certain reading of a contract doesn't 
make sense (and that has nothing to do with "intent"), then that obviously 
cannot be what either party really agreed to.

Oh, and documented intent can be used for laches, ie it can be a _defense_ 
against an accusation. If somebody has publicly stated some intent, he 
can't really complain later when somebody else tried to fulfill his 
intent, can he?

			Linus

PS. "Intent" can obviously have a _totally_ different legal meaning too. 
The difference between "murder" and "manslaughter" is about pre-meditation 
- ie "intent". But that's not an issue in licenses/contracts, except for a 
very specific _kind_ of "contract" - the kind the Mob puts out on people 
it wants to get rid of ;)

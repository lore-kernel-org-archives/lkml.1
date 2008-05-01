Return-Path: <linux-kernel-owner+w=401wt.eu-S1755817AbYEABU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755817AbYEABU3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 21:20:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbYEABUR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 21:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53930 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751956AbYEABUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 21:20:16 -0400
Date: Wed, 30 Apr 2008 18:19:56 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Willy Tarreau <w@1wt.eu>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Slow DOWN, please!!!
In-Reply-To: <200805010242.36775.rjw@sisk.pl>
Message-ID: <alpine.LFD.1.10.0804301811051.5994@woody.linux-foundation.org>
References: <20080429.190352.137408408.davem@davemloft.net> <20080430224610.GO8474@1wt.eu> <alpine.LFD.1.10.0804301555330.2980@woody.linux-foundation.org> <200805010242.36775.rjw@sisk.pl>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 May 2008, Rafael J. Wysocki wrote:
> 
> > I do _not_ want to slow down development by setting some kind of "quality 
> > bar" - but I do believe that we should keep our quality high, not because 
> > of any hoops we need to jump through, but because we take pride in the 
> > thing we do.
> 
> Well, we certainly should, but do we always remeber about it?  Honest, guv?

Hey, guv, do you _honestly_ believe that some kind of ISO-9000-like 
process generates quality?

And I dislike how people try to conflate "quality" and "merging speed" as 
if there was any reason what-so-ever to believe that they are related.

You (and Andrew) have tried to argue that slowing things down results in 
better quality, and I simply don't for a moment believe that. I believe 
the exact opposite.

The way to get good quality is not to put barriers up in front of 
developers, but totally the reverse - by helping them. And yes, that help 
can quite possibly be in the form of "process" - by making things more 
streamlined, and by having people not have to waste time on wondering 
where they should send things etc.

But the notion that we should even _try_ to aim to slow things down, that 
one I find unlikely to be true, and I don't even understand why anybody 
would find it a logical goal?

Of course, you will have fewer new bugs if you have fewer changes. But 
that's not a goal, that's a tautology and totally uninteresting. A small 
program is likely to have fewer bugs, but that doesn't make something 
small "better" than something large that does more.

Similarly, a stagnant development community will introduce new bugs more 
seldom. But does that make a stagnant one better than a virbrant one? Hell 
no.

So what I'm arguing against here is not that we should aim for worse 
quality, but I'm arguing against the false dichotomy of believing that 
quality is incompatible with lots of change. 

So if we can get the discussion *away* from the "let's slow things down", 
then I'm interested. Because at that point we don't have to fight made-up 
arguments about something irrelevant.

			Linus

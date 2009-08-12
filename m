Return-Path: <linux-kernel-owner+w=401wt.eu-S1751393AbZHLV21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751393AbZHLV21 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 17:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751269AbZHLV21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 17:28:27 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:35787 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZHLV20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 17:28:26 -0400
Date: Wed, 12 Aug 2009 22:25:02 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Pavel Machek <pavel@ucw.cz>, Joe Perches <joe@perches.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090812212502.GA24667@n2100.arm.linux.org.uk>
References: <4A7ACC8D.7030706@xenontk.org> <20090806124048.GD27773@flint.arm.linux.org.uk> <1249563730.10297.13.camel@Joe-Laptop.home> <20090806133349.GF27773@flint.arm.linux.org.uk> <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249948147.8895.96.camel@Joe-Laptop.home> <20090812115520.GI24339@elf.ucw.cz> <20090812194838.GB12117@n2100.arm.linux.org.uk> <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 12, 2009 at 11:17:54PM +0300, Pekka Enberg wrote:
> On Wed, Aug 12, 2009 at 10:48 PM, Russell King - ARM
> Linux<linux@arm.linux.org.uk> wrote:
> > I haven't noticed a great rush of support for Joe's patch, which
> > could mean that people here really aren't that bothered - maybe
> > they just aren't "open list" zealots like some people seem to be.
> 
> I for one support open lists because subscriber-only lists are a PITA

Let me make this clear, yet again.  The lists are *not* subscriber only
lists.  We do NOT reject non-subscriber posts for no reason what so ever
(although it does seem to have happened, both Erik and myself both
contend that we have never rejected a mailing intentionally without
giving a reason - whether the original poster receives that reason is
a function of how buggy mailman is.)

> for contributors who send out patches to multiple subsystems. However,
> if you (and the rest of the arm people) don't see the value of opening
> the list up, why do you expect people to rush to support Joe's patch?
> It's you who is losing out on contributors and if you don't see that
> (or don't agree), you probably should keep the list subscriber-only,
> no?

Rather than twisting what I said "if you don't see the value why do you
expect people to rush..." what I actually said is precisely the opposite
- I don't see people rushing to support Joe's patch - that has a
completely different meaning.  I also don't see lots of people saying
"yes we should move over to vger".

The linux-arm at vger list has been published here a couple of times
and despite giving people a free choice, there's been very little
movement over to it.  In my opinion, that speaks _volumes_.  Maybe
that's because people prefer the mailman web interface for subscription,
Just a guess judging from the help I used to give people with the 1990s
majordomo.

Moreover, vger is trying to replicate the setup we had back in the
early 90s, which was found to be sub-optimal - we split the lists
into kernel stuff, userspace stuff and toolchain stuff to reduce the
amount of ignored postings - so that people specialising in ARM
userspace didn't have to wade through all the (vastly more) kernel
discussions.  Unfortunately, the new setup at vger would mean re-
combining the lists.  Maybe that's another factor that people don't
like?  Don't know.

Maybe people don't like that we're having the vger list forced upon us
by a minority rather than the community coming to its own decision on
the subject?  Again, just a theory.

There is also a feeling from some people in this community (they've told
me themselves in private) that certain mainline folk have been actively
trying to undermine the ARM community - given the recent "discussions"
(more like flames) over things like the device tree, the HTC stuff, etc.
Given that, how do you think having another mailing list forced upon us
would be received?

I don't know what the reasons are, but unless there is gets proper
concensus and agreement, having yet another list just in the name of
"openness" is just going to create yet more problems by fragmenting
the community.

The other relevent point here is that these mailing lists provide me with
a _good_ platform for long-term testing of ARM kernels.  These lists run
on an ARM machine.  Take that away, and the amount of long-term testing
drops back to whatever happens in the embedded developer space... which
I suspect is almost nil.  (Show me an embedded developer who, as part
of their testing, keeps the board running without reboot under varying
amounts of load for anything approaching or exceeding several months.)

Now, given that I've proved people wrong time and time again on the way
we run these mailing lists (eg, the "none of the posts which get held
for moderation actually get through" and I've subsequently provided
people with links to their disputed posts in the archive, including
the one which Pavel started this thread about _after_ that message was
allowed through) (a) is having this long and extensive discussion really
necessary and (b) is it actually being productive or is it just wasting
peoples time (consider that I've spent over an hour putting this reply
together... and I'm sure it's going to get picked through, which'll
add yet more replies which I'll spend yet more time reading and replying
to)?

I have a theory.  People only complain about moderated mailing lists
because they get messages telling them that their message has been
caught.  If moderated mailing lists didn't send back that message,
(and the queue was processed in a timely manner) people would not
complain one bit.  So it is probably far better if I bend mailman
such that it doesn't send out moderation messages - certainly to
anyone called Pavel. ;)

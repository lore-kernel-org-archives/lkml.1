Return-Path: <linux-kernel-owner+w=401wt.eu-S1751921AbZHLWAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbZHLWAl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 18:00:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZHLWAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 18:00:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:37964 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbZHLWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 18:00:40 -0400
Date: Thu, 13 Aug 2009 00:00:30 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, Joe Perches <joe@perches.com>,
       Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090812220029.GA1387@ucw.cz>
References: <20090806124048.GD27773@flint.arm.linux.org.uk> <1249563730.10297.13.camel@Joe-Laptop.home> <20090806133349.GF27773@flint.arm.linux.org.uk> <1249568614.10297.20.camel@Joe-Laptop.home> <20090806150322.GX2080@trinity.fluff.org> <1249948147.8895.96.camel@Joe-Laptop.home> <20090812115520.GI24339@elf.ucw.cz> <20090812194838.GB12117@n2100.arm.linux.org.uk> <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com> <20090812212502.GA24667@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090812212502.GA24667@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I haven't noticed a great rush of support for Joe's patch, which
> > > could mean that people here really aren't that bothered - maybe
> > > they just aren't "open list" zealots like some people seem to be.
> > 
> > I for one support open lists because subscriber-only lists are a PITA
> 
> Let me make this clear, yet again.  The lists are *not* subscriber only
> lists.  We do NOT reject non-subscriber posts for no reason what so ever
> (although it does seem to have happened, both Erik and myself both
> contend that we have never rejected a mailing intentionally without
> giving a reason - whether the original poster receives that reason is
> a function of how buggy mailman is.)

FAQ still states that cc-ing between l-k and lakml is
unwelcome. Reason why people prefer open lists is that you can cc both
l-k and the other relevant list.

> Moreover, vger is trying to replicate the setup we had back in the
> early 90s, which was found to be sub-optimal - we split the lists
> into kernel stuff, userspace stuff and toolchain stuff to reduce the
> amount of ignored postings - so that people specialising in ARM
> userspace didn't have to wade through all the (vastly more) kernel
> discussions.  Unfortunately, the new setup at vger would mean re-
> combining the lists.  Maybe that's another factor that people don't
> like?  Don't know.

I'd say that linux-arm@vger._kernel_.org is meant for kernel
discussion, so no, it is not trying to mix kernel&userspace.

> I have a theory.  People only complain about moderated mailing lists
> because they get messages telling them that their message has been
> caught.  If moderated mailing lists didn't send back that message,
> (and the queue was processed in a timely manner) people would not
> complain one bit.  So it is probably far better if I bend mailman
> such that it doesn't send out moderation messages - certainly to
> anyone called Pavel. ;)

Yes, those messages are indeed annoying.

If you can indeed process queue in timely manner, and remove FAQ entry
about not cc-ing between open lists and lakml, then yes, that would
probably be good-enough emulation of open list.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755282AbZHNL0I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282AbZHNL0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 07:26:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZHNL0H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 07:26:07 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53674 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755126AbZHNL0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 07:26:06 -0400
Date: Fri, 14 Aug 2009 13:25:56 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Mack <daniel@caiaq.de>, Joe Perches <joe@perches.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Ben Dooks <ben-linux@fluff.org>,
       linux-arm-kernel@lists.arm.linux.org.uk,
       David John <davidjon@xenontk.org>, Erik Mouw <mouw@nl.linux.org>,
       kernel list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>, Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: [PATCH] MAINTAINERS: Add "L: linux-arm@vger.kernel.org" to ARM
	sections
Message-ID: <20090814112556.GK32418@elf.ucw.cz>
References: <84144f020908121317g64551a2cu1b960f44ed5d0d9@mail.gmail.com> <20090812212502.GA24667@n2100.arm.linux.org.uk> <20090813103511.2928a085@lxorguk.ukuu.org.uk> <20090813094736.GZ6132@n2100.arm.linux.org.uk> <1250158593.28285.23.camel@Joe-Laptop.home> <20090813103513.GC6132@n2100.arm.linux.org.uk> <1250161714.28285.61.camel@Joe-Laptop.home> <20090813115444.GB10450@n2100.arm.linux.org.uk> <20090814075919.GG19257@buzzloop.caiaq.de> <20090814091808.GA2662@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090814091808.GA2662@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-08-14 10:18:08, Russell King - ARM Linux wrote:
> On Fri, Aug 14, 2009 at 09:59:19AM +0200, Daniel Mack wrote:
> > One common false positive to this rule is using 'git send-email' with a
> > message ID as reference. There won't be a 'Re:' in that case.
> 
> Yes, and they are HELD FOR MODERATION so that a HUMAN can make a DECISION
> on whether to let them through.  We could, alternatively, discard them
> outright.  We think that discarding due to a rule matching is unacceptable
> though.
> 
> These lists are getting close to me just pulling the plug on them.  The
> amount of crap flying around about them is getting too great for me to
> continue to provide such a service to this community.  When I pull them,
> I'll pull *all* the linux-arm related lists.
> 
> Someone else can provide and run the mailing lists.

davem indicated that he's happy to run the mailing lists.

Now, I don't know why you are pulling non-kernel arm-related maillists
into the picture. Those are not normally cced by kernel people, so
they not cause problems. Blackmail?

> I estimate that this will happen this evening.  Really.  Because I don't
> see this thread settling down.

If pulling the plug on them is the only way to get useful mailing list
for linux-arm-kernel, go ahead!
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

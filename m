Return-Path: <linux-kernel-owner+w=401wt.eu-S1756650AbZFLMFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650AbZFLMFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754343AbZFLMFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:05:16 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47262 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725AbZFLMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:05:15 -0400
Date: Fri, 12 Jun 2009 14:05:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090612120506.GS18682@elf.ucw.cz>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk> <4A31B061.3080102@bluewatersys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A31B061.3080102@bluewatersys.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2009-06-12 13:33:21, Ryan Mallon wrote:
> Russell King - ARM Linux wrote:
> > On Thu, Jun 11, 2009 at 05:00:30AM -0700, David Miller wrote:
> >> From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> >> Date: Thu, 11 Jun 2009 12:49:12 +0100
> >>
> >>> I can not keep up with the number of patches that need to be
> >>> reviewed and ultimately merged.  I know this, and I freely admit it,
> >>> and I have done so on many occasions.
> >> Then split up the responsibilities to other people instead of being
> >> the choke point.  Controlling everything isn't so important.
> > 
> > Don't you think that I've been trying to get other people to be more
> > involved?
> > 
> > - I've been pushing people to send patches to the relevent mailing
> >   list(s) and maintainer(s) for years.
> > 
> > - I've been pushing people to send their ARM patches to the ARM
> >   mailing list rather than directly into the patch system for review
> >   (it even has a comment telling people this) so that others can get
> >   involved in reviewing them, and sharing that work load.
> > 
> > Do you think either have been anywhere near successful?
> > 
> > For the most part, the answer is no.  People concentrate on their own
> > areas, and won't look at someone with a new class of platforms (eg,
> > the STMP or W90x900 stuff).
> > 
> > I'd absolutely love it if the review load could be shared, but for the
> > most part it just doesn't happen.  Everyone's far too busy with their
> > own stuff to help out (and that's a reason that they'll give if tackled
> > head on about it.)
> 
> Question on this: I occasionally review patches where I have the
> knowledge or interest. Most of the time however, I do not have the
> hardware needed to actually test the patches, and so my reviews are
> simply coding style, etc. I don't want to add my acked-by to something I
> can't test, or am not at reasonably confident is okay (ie haven't
> tested, but know the hardware well enough to be satisfied the patch is
> okay by reading it).
> 
> The problem I see for developers I do reviews for, is that they post a
> patch, I do a code review, the post an update looking for an acked-by,
> and the best I can say is "looks okay to me, but get someone else to ack
> it". Whats the best approach here? Should I just add my Reviewed-by tag,
> or should can/should I ack patches where I think the code is okay, but
> can't test.

I believe you have slightly higher standards than
neccessary/desirable.

I believe it is okay to ack a patch when you don't have a hardware;
you can trust original submitter to test it on the hw. As long as the
patch is not broken by design, or contain some gross uglyness...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

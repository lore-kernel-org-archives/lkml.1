Return-Path: <linux-kernel-owner+w=401wt.eu-S1757771AbZFKNVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757771AbZFKNVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754253AbZFKNVY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:21:24 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:59773 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbZFKNVX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:21:23 -0400
Date: Thu, 11 Jun 2009 15:21:17 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, swetland@google.com,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       san@android.com, rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
Message-ID: <20090611132117.GH7523@elf.ucw.cz>
References: <20090611111821.GK795@n2100.arm.linux.org.uk> <20090611.042226.28424489.davem@davemloft.net> <20090611114911.GL795@n2100.arm.linux.org.uk> <20090611.050030.169859977.davem@davemloft.net> <20090611123852.GM795@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090611123852.GM795@n2100.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2009-06-11 13:38:52, Russell King - ARM Linux wrote:
> On Thu, Jun 11, 2009 at 05:00:30AM -0700, David Miller wrote:
> > From: Russell King - ARM Linux <linux@arm.linux.org.uk>
> > Date: Thu, 11 Jun 2009 12:49:12 +0100
> > 
> > > I can not keep up with the number of patches that need to be
> > > reviewed and ultimately merged.  I know this, and I freely admit it,
> > > and I have done so on many occasions.
> > 
> > Then split up the responsibilities to other people instead of being
> > the choke point.  Controlling everything isn't so important.
> 
> Don't you think that I've been trying to get other people to be more
> involved?
> 
> - I've been pushing people to send patches to the relevent mailing
>   list(s) and maintainer(s) for years.

The patch system is actively harmful here, because you either send the
system for discussion, or for inclusion. Picking the patches from the
mailing list when there are no significant comments (as done on lkml)
seems to work better. 

> If patchwork can replace what my patch system does for me (which is
> basically to help ensure that patches don't get lost which need
> applying - that's different from logging every single patch) then
> I'll gladly look at it.  It will mean that some of the sanity checks
> on the patch content, which happen automatically with the patch system,
> will need to be done manually.
> 
> If patchwork just gathers up every patch which has ever been seen on
> a mailing list, then stuff will get lost at a higher rate than today
> and it will have a negative impact.

I believe you are concentrating on "patch loss rate" a bit too
much. lkml does have higher "patch loss rate", still it seems
better/nicer/easier to work with.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

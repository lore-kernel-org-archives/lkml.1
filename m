Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbXKLQ4s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbXKLQ4s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:56:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXKLQ4k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:56:40 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36664 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754131AbXKLQ4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:56:39 -0500
Date: Mon, 12 Nov 2007 17:56:16 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Tuomo Valkonen <tuomov@iki.fi>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [poll] Is the megafreeze development model broken?
Message-ID: <20071112165616.GM9771@stusta.de>
References: <fgtfqa$h9j$1@ger.gmane.org> <m1sl3b4t5k.fsf@ebiederm.dsl.xmission.com> <slrnfjgmit.l07.tuomov@jolt.modeemi.cs.tut.fi> <20071112152057.GJ9771@stusta.de> <20071112160254.GA31972@jolt.modeemi.cs.tut.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071112160254.GA31972@jolt.modeemi.cs.tut.fi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2007 at 06:02:54PM +0200, Tuomo Valkonen wrote:
> On 2007-11-12 16:20 +0100, Adrian Bunk wrote:
> > The problem is not what the distributions ship, the problem is simply 
> > that problems with distribution packaged software should be reported 
> > to the distribution, not upstream.
> > 
> > And for becoming at least marginally on-topic again:
> > Assuming your "stable base systems" contains the Linux kernel, how would
> > you prevent users from reporting bugs in their ancient kernels [1] here?
> 
> You obviously can't prevent them from reporting problems, but you can
> dissuade them from doing that.

Yes, by asking immediately
  Is this issue still present with $latest_upstream_version?

If you don't do this for Ion then that's your fault.

> The kernel (and "Linux" in general)
> being rather "generic" and faceless in the sense I mentioned in the
> previous post does work to that end, and users are more aware that 
> "it's the Debian kernel", than it's, say, "a Debian-corrupted 
> ancient development snapshot of Ion". The Debian kernel packages
> are not even called 'Linux', just 'kernel',
>...

Let's check your statement against reality:

They are called linux-*

>...
> > But the good thing about open source software is that when you believe 
> > your ideas are better than what current distributions do you can 
> > implement your ideas and create your own distribution. 
> 
> Haha, the typical FOSS advocate's fallacy. Quote:
>...

Open source development does not work by whining and trying to spread 
your opinion through fake "polls" - either you implement what you want
yourself or it won't happen.

That's the simple truth, and it's your time that you waste when you 
continue to complain. It also took me a few years until I learned this 
lesson.

But an important observation is that when you start something other 
people consider worthwhile there will be other people who participate in 
what you do, or who even continue it when you decide to switch to other 
projects instead.

> Tuomo

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1754318AbXICM3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318AbXICM3r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2007 08:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752316AbXICM3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Sep 2007 08:29:39 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:46597 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752164AbXICM3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2007 08:29:38 -0400
Date: Mon, 3 Sep 2007 14:29:40 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Natalie Protasevich <protasnb@gmail.com>, David Rees <drees76@gmail.com>,
       Daniel Walker <dwalker@mvista.com>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       =?utf-8?B?QmrDtnJu?= Steinbrink <B.Steinbrink@gmx.de>,
       eranian@hpl.hp.com, ak@suse.de, linux-kernel@vger.kernel.org,
       Al Boldi <a1426z@gawab.com>
Subject: Re: Who wants to maintain KR list for stable releases?
Message-ID: <20070903122940.GU16016@stusta.de>
References: <20070827005131.b93f5935.akpm@linux-foundation.org> <6bffcb0e0708270438j4c92a0b4m1396b4010f25bfb5@mail.gmail.com> <1188227585.2435.192.camel@dhcp193.mvista.com> <6bffcb0e0708270826p7a7fb044re53d0db4094bc3d5@mail.gmail.com> <1188229197.2435.207.camel@dhcp193.mvista.com> <72dbd3150708271212w6bcca4c4web26d7cb25892afc@mail.gmail.com> <32209efe0708290042g362fbfadj38fe57e0de7f3af@mail.gmail.com> <20070829222344.GV26410@stusta.de> <32209efe0708291659w1f75adbcrf72e61a9325903da@mail.gmail.com> <46D6E135.8000203@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <46D6E135.8000203@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2007 at 05:24:37PM +0200, Stefan Richter wrote:
>...
> Al Boldi wrote in "Designers and Builders (was: Who wants to maintain KR
> list for stable releases?)":
> | So, what's wrong with tapping into people's design suggestions, and
> | allowing others to implement it?
> 
> Design suggestions should really come from people who also know a lot
> about the how-to.  This is even true to some degree about feature
> requests.  Besides, I've got a feeling that regardless of the field of
> τεχνη one works in, someone can only be a truly good designer if she or
> he has also been a builder.
> 
> But back to the discussion.  A tracker is not a good tool for
> brainstorming sessions, except perhaps for capturing conclusions after
> the brainstorm, as far as they are suitable as input for actual work.
> 
> Also, "*allowing* others to implement it" has a strange ring to me.
> Where I am around, there are always far too few people who fix things
> and build things.  But very, very occasionally there is someone new who
> wonders if there is an interesting TODO item which is perhaps in the
> reach of his abilities.  Contributing a cleanup or an actual feature is
> typically much easier than fixing an open, tracked bug.  (The bugs which
> end up in the bugtracker are usually the difficult ones.)  The
> contributor learns something and, in a rare turn of events, may
> eventually become able and willing to join the bugfixing.

"Contributing a cleanup" is what the Kernel Janitor Project
already offers.

But "Contributing an actual feature" is much harder:

You need a feature:
- with a realistic chance of being included and
- hard enough that the person suggesting it doesn't simply implement it
  himself instead of requesting it and
- easy enough that a newbie can implement it.

And the code should then be in a reasonable shape for being merged.

IMHO that's nearly impossible.

Realistically, offering a TODO item for a feature would require the one 
proposing it to do an amount of mentoring work that is not smaller than 
the amount of work he had to spend if implementing it himself.

This might be worth it if you know for sure the person you are mentoring 
stays active after completion of the feature - but this assumption is 
too often not true.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


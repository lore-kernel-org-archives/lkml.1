Return-Path: <linux-kernel-owner+w=401wt.eu-S1161527AbXD2WUr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161527AbXD2WUr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:20:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161521AbXD2WUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:20:47 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32887 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161519AbXD2WTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:19:47 -0400
Date: Mon, 30 Apr 2007 00:19:58 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429221958.GX3468@stusta.de>
References: <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <20070429225657.a501ab5a.diegocg@gmail.com> <20070429211028.GT3468@stusta.de> <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com> <20070429212128.GU3468@stusta.de> <1177883521.5791.156.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1177883521.5791.156.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 11:52:01PM +0200, Thomas Gleixner wrote:
> On Sun, 2007-04-29 at 23:21 +0200, Adrian Bunk wrote:
> > >> > It's not great but it's the best clone of you we've found 8)
> > >>
> > >> What exactly is the purpose of the 2.6.21 regressions list in the Wiki?
> > >
> > > It's for -stable team.
> > >...
> > 
> > Did Greg or Chris say they have spare time for going through this list?
> 
> Don't be silly, did any of the developers say, that he has spare time to
> read your regression lists ?

It worked because several people (including Linus) emphasized that 
fixing regressions from this list was important.

And it failed because many regressions still stayed unfixed and some 
even undebugged.

> Michal posted it to LKML with the relevant developers in CC including
> the stable team, so they are in the loop for updates, which is a Good
> Thing!
> 
> Hey, you did this yourself. It is a great help and as your lists did,
> Michals list pointed me to a bug, which I would have missed otherwise. 
> 
> So what are you complaining about ? Folks stepped up and built a
> regression list and posted it to LKML. What's wrong with that ?

If it works it's perfectly fine.

> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S1757849AbYDZOog@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbYDZOog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 10:44:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbYDZOo2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 10:44:28 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:58686 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751308AbYDZOo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 10:44:28 -0400
Date: Sat, 26 Apr 2008 17:44:04 +0300
From: Adrian Bunk <bunk@stusta.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426144404.GG2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426112717.GA23248@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426112717.GA23248@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 01:27:17PM +0200, Sam Ravnborg wrote:
> Hi Adrian.

Hi Sam,

> > Why do other people get over 100 checkpatch fixes into the tree at once 
> > or Linus applies patches directly bypassing the maintainers (like the 
> > one you sent just before [3], which I've also already sent before [4]) 
> > but my patches bitrot forever?
> 
> The patches you submit touches all parts of the kernel tree.
> And you do a good job in finding the relevant receivers.
> 
> To me you are partly in the saem situation as Andrew in that
> you handle a great deal of patches touching a lot of different
> subsystems.
>...

Linus takes patches from people like Andrew, Al and Harvey directly,
but he doesn't take the same patches directly from me.

Whatever applies to these people doesn't help me.

> So in your position I would keep all patches in
> a place so they can be sucked into -next and regular spam
> the relevant amintainers with their patches.
> When the merge window opens then submit the rest to Linus
> with a noe that they have been sent to Maintainers without
> any feedback previously.
> 
> This is not far away from what you do now and should not create
> that big frustrations (I hope).

You missed the "And Linus didn't even bother to answer what the correct 
path for my patches is."

I'd have no problem creating a git tree for such stuff.

But if Linus doesn't bother to tell me how he wants to get patches from 
me he most likely also won't bother to pull from my tree.


And it wouldn't be usable for bugfixes that should get into 2.6.26.

It might e.g. make sense to let maintainers handle fixes and let them 
decide whether they want a patch this way, but if my patch goes through 
the maintainer and later Linus applies the same patch by someone else 
directly it simply makes no sense that I spend my spare time on fixing 
bugs in the kernel.


> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


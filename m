Return-Path: <linux-kernel-owner+w=401wt.eu-S1758341AbYDZPYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758341AbYDZPYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2008 11:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbYDZPYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Apr 2008 11:24:07 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:59199 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753603AbYDZPYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2008 11:24:06 -0400
Date: Sat, 26 Apr 2008 18:23:41 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: If you want me to quit I will quit
Message-ID: <20080426152341.GI2252@cs181133002.pp.htv.fi>
References: <1209190455.14173.13.camel@brick> <20080426110044.GB2252@cs181133002.pp.htv.fi> <20080426075132.b0fdbe13.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080426075132.b0fdbe13.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2008 at 07:51:32AM -0700, Andrew Morton wrote:
> On Sat, 26 Apr 2008 14:00:44 +0300 Adrian Bunk <bunk@kernel.org> wrote:
> 
> > Why do other people get over 100 checkpatch fixes into the tree at once 
> > or Linus applies patches directly bypassing the maintainers (like the 
> > one you sent just before [3], which I've also already sent before [4]) 
> > but my patches bitrot forever?
> 
> If I am not cc'ed on a patch and have to resort to plucking it off the
> mailing list it ends up being significantly more work and more error-prone
> for me to process it.
> 
> I used to merge your patches but then you chose to stop ccing me on them so
> I stopped applying them.  The increased hassle just isn't worth it for some
> random make-foo-static patch.  I do try to keep an eye out for more
> significant changes but hey, stuff happens.
> 
> You chose to disrupt the workflow and now you're here complaining and blaming
> others for the consequences of your own action.


Why didn't you tell me an explicit Cc is important for you?

I'll resend my pending batch with a Cc to you.


That only leaves the question why bugfixes are directly applied by Linux 
when they come from other people, but not when they come from me. Is 
there also a Cc required? But my patch for the x86 userspace headers 
fuckup was Cc'ed to Linus (and I can't send it to -stable before it is 
in Linus' tree).

Is the correct path for bug fixes to go through the maintainer or to go 
directly through Linus? And in the latter case, what was wrong with my 
patches?


cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


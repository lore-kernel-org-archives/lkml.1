Return-Path: <linux-kernel-owner+w=401wt.eu-S1031447AbXD2Wmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031447AbXD2Wmq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 18:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031334AbXD2Wmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 18:42:46 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32902 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031452AbXD2Wmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 18:42:45 -0400
Date: Mon, 30 Apr 2007 00:42:56 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429224256.GA23336@stusta.de>
References: <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <20070429225657.a501ab5a.diegocg@gmail.com> <20070429211028.GT3468@stusta.de> <6bffcb0e0704291416u402668ffo9bcaafb389228981@mail.gmail.com> <20070429212128.GU3468@stusta.de> <1177883521.5791.156.camel@localhost.localdomain> <20070429221958.GX3468@stusta.de> <1177886010.5791.166.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1177886010.5791.166.camel@localhost.localdomain>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2007 at 12:33:30AM +0200, Thomas Gleixner wrote:
> On Mon, 2007-04-30 at 00:19 +0200, Adrian Bunk wrote:
>...
> > And it failed because many regressions still stayed unfixed and some 
> > even undebugged.
> 
> No it failed not. It is not perfect. Way more bugs, which have been
> fixed or are in the debugging process, would have been unnoticed and
> ignored otherwise.
>...

It depends on what you consider failure and what you consider success.

For me, it failed. Not because it wasn't perfect, but because we could 
have done much better with fixing the known regressions, and also by not 
introducing several regressions between the last -rc and the final 
kernel (and people who did test -rc7 and would most likely also have 
tested an -rc8 ran into them).

> 	tglx

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


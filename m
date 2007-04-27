Return-Path: <linux-kernel-owner+w=401wt.eu-S1755964AbXD0O55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964AbXD0O55 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:57:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755955AbXD0O55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:57:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:36533 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755964AbXD0O5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:57:55 -0400
Date: Fri, 27 Apr 2007 16:58:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070427145805.GT3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <20070426165950.GO3468@stusta.de> <20070426215015.003f6196@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070426215015.003f6196@the-village.bc.nu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 09:50:15PM +0100, Alan Cox wrote:
> > They get frustrated because they focussed on developing new features 
> > instead of fixing regressions, and now it takes longer until their new 
> > features get merged because noone fixed the regressions...
> 
> I would disagree: They get frustrated because they are blocked on some
> small regression which is stopping a ton of other fixed including
> features people need (like new hardware support) from being released.
> 
> The "no regressions" model doesn't really work when you ask about the
> greater good of the userbase.
> 
> The goal of no regressions is great and the regression lists for ATA were
> certainly very helpful but the greater good comes first.

"no regressions" is definitely not feasible.

14 known regressions, some of them not yet debugged at all, are 
different from your "some small regression".

And look e.g. at the many (and non-trivial) changes between -rc7 and 
-final, resulting in more than one report from people who were running 
-rc7 without problems - and 2.6.21 doesn't work for them.

It's not a choice between "regressions don't matter" and "no regressions",
it's about the place in the area between these two extremes. I have my 
opinions on what I want to expect from a stable Linux kernel, and other 
people have different opinins.

> Alan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


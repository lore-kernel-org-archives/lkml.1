Return-Path: <linux-kernel-owner+w=401wt.eu-S932819AbXDZEH5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819AbXDZEH5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 00:07:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932837AbXDZEH5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 00:07:57 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:34699 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932819AbXDZEH4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 00:07:56 -0400
Date: Thu, 26 Apr 2007 06:08:06 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426040806.GJ3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 08:29:28PM -0700, Linus Torvalds wrote:
>...
> So it's been over two and a half months, and while it's certainly not the 
> longest release cycle ever, it still dragged out a bit longer than I'd 
> have hoped for and it should have. As usual, I'd like to thank Adrian (and 
> the people who jumped on the entries Adrian had) for keeping everybody on 
> their toes with the regression list - there's a few entries there still, 
> but it got to the point where we didn't even know if they were real 
> regressions, and delaying things further just wasn't going to help.
>...


Number of different known regressions compared to 2.6.20 at the time
of the 2.6.21 release:
14

Number of different known regressions compared to 2.6.20 at the time
of the 2.6.21 release that were first reported in March or earlier:
8

Number of different known regressions compared to 2.6.20 at the time
of the 2.6.21 release with patches available at the time of the 2.6.21 
release [1]:
3

What I will NOT do:
Waste my time with tracking 2.6.22-rc regressions.


We have an astonishing amount of -rc testers, but obviously not the 
developer manpower for handling them.

If we would take "no regressions" seriously, it might take 4 or 5 months 
between releases due to the lack of developer manpower for handling 
regressions. But that should be considered OK if avoiding regressions 
was considered more important than getting as quick as possible to the 
next two week regression-merge window.

But releasing with so many known regressions is insulting for the many 
people who spent their time testing -rc kernels.


cu
Adrian

[1] http://lkml.org/lkml/2007/4/25/496

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


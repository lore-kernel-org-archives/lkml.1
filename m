Return-Path: <linux-kernel-owner+w=401wt.eu-S1031211AbXDZM5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031211AbXDZM5x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031219AbXDZM5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:57:52 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35191 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031211AbXDZM5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:57:51 -0400
Date: Thu, 26 Apr 2007 14:58:02 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426125802.GL3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070426040806.GJ3468@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

A clarification:

I am aware that my work had some effect, and I am aware that my work 
gets appreciated - there's no need for everyone to repeat this.

The point is: I'm not satisfied with the result.

Linus said 2.6.20 was a stable kernel. My impression was that at least 
two of the regressions from my 2.6.20 regressions list should have been 
fixed before 2.6.20.

They have both been fixed through -stable, but I also remember a quite 
experienced kernel maintainer running into one of them after 2.6.20 was 
released and spending half a day tracking it down - and my answer was
"known unfixed regression, first reported more than a month ago".

There is a conflict between Linus trying to release kernels every
2 months and releasing with few regressions.

Trying to avoid regressions might in the worst case result in an -rc12 
and 4 months between releases. If the focus is on avoiding regressions 
this has to be accepted.

And a serious delay of the next regression-merge window due to unfixed 
regressions might even have the positive side effect of more developers 
becoming interested in fixing the current regressions for getting their 
shiny new regressions^Wfeatures faster into Linus' tree.

0 regressions is never realistic (especially since many regressions 
might not be reported during -rc), but IMHO we could do much better than 
what happened in 2.6.20 and 2.6.21.

These are just my personal opinions, and other people consider the 
resulting 2.6.20 and 2.6.21 kernels OK.

I'm not satisfied with the result, and the world won't stop turning when 
I'm not tracking 2.6.22-rc regressions.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


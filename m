Return-Path: <linux-kernel-owner+w=401wt.eu-S1030761AbXDZMcO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030761AbXDZMcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 08:32:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031216AbXDZMcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 08:32:14 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:35175 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030761AbXDZMcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 08:32:13 -0400
Date: Thu, 26 Apr 2007 14:32:24 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Daniel Barkalow <barkalow@iabervon.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070426123224.GK3468@stusta.de>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org> <20070426040806.GJ3468@stusta.de> <Pine.LNX.4.64.0704260133271.28708@iabervon.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0704260133271.28708@iabervon.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2007 at 02:46:08AM -0400, Daniel Barkalow wrote:
> 
> On Thu, 26 Apr 2007, Adrian Bunk wrote:
> 
> > Number of different known regressions compared to 2.6.20 at the time
> > of the 2.6.21 release:
> > 14
> 
> I count 13. (v2) had 15 items, of which 2 were subsequently fixed or found 
> to be inapplicable.

Plus one that has been reported since my last list.

> > Number of different known regressions compared to 2.6.20 at the time
> > of the 2.6.21 release with patches available at the time of the 2.6.21 
> > release [1]:
> > 3
> 
> The -stable team can presumably take care of these in 2.6.21.1, right? 

Two of them are heavily discussed patches, and I'm therefore not sure 
they will ever reach the 2.6.21 branch now that the attention has been 
shifted away from 2.6.21 regressions.

> That leaves 10 that need developer attention.
> 
>  John Stultz seems to be taking care of 3 of them.
> 
>  Oliver Neukum has 1.
> 
>  2 are particular drivers (ali_pata and rtl8139, according to the 
>  reports).
> 
>  2 seem to be ACPI-related; at least one has a candidate patch now.
> 
>  1 seems to be an ALSA problem.
> 
>  1 is STD and being debugged.

You are overinterpreting the Handled-By field in my reports.

It does not imply that this person promised to fix this issue, it only 
says that this person is or was working on this issue.

And more than 50% of the issues were reported first last month or 
earlier and are still unfixed despite repeated reminder emails - if
they weren't fixed until now they might as well become similar to
"foo seems to be broken since at about 2.6.9" issues.

It sounds highly unrealistic that all issues unfixed for a month 
suddenly become fixed even though the main focus of everyone shifts to 
2.6.21.

> It looks like all of the known regressions are being worked on, and 
> getting fixes in for them is -stable material at this point. Furthermore, 
> it doesn't look to me like anyone who is needed for dealing with these 
> regressions is trying to get stuff into the 2.6.22 merge window.
>...

That's a wrong impression, nearly every active kernel developer has at 
least one patch pending for 2.6.22.

> 	-Daniel

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


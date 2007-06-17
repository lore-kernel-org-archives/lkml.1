Return-Path: <linux-kernel-owner+w=401wt.eu-S1760659AbXFQSYw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760659AbXFQSYw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 14:24:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757592AbXFQSYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 14:24:44 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37659 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757321AbXFQSYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 14:24:44 -0400
Date: Sun, 17 Jun 2007 20:24:57 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Oleg Verych <olecom@flower.upol.cz>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070617182457.GY3588@stusta.de>
References: <alpine.LFD.0.98.0706151618380.14121@woody.linux-foundation.org> <20070615234202.GP3588@stusta.de> <20070616013236.GA16016@flower.upol.cz> <4673D63D.5020804@s5r6.in-berlin.de> <20070617004436.GU3588@stusta.de> <467501D0.3090203@googlemail.com> <20070617124508.GV3588@stusta.de> <6bffcb0e0706170617k32e79d96q5af1bcd7d9492cb8@mail.gmail.com> <20070617142950.GW3588@stusta.de> <467560CF.6090100@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <467560CF.6090100@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 06:26:55PM +0200, Stefan Richter wrote:
> Adrian Bunk wrote:
> >>> And we should be aware that reverting is only a workaround for the real
> >>> problem which lies in our bug handling.
> >> ...
> > 
> > And this is something I want to emphasize again.
> > 
> > How can we make any progress with the real problem and not only the 
> > symptoms?
> ...
> 
> Perhaps make lists of
> 
>   - bug reports which never lead to any debug activity
>     (no responsible person/team was found, or a seemingly person/team
>     did not start to debug the report)
> 
>   - known regressions on release,
> 
>   - regressions that became known after release,
> 
>   - subsystems with notable backlogs of old bugs,
> 
>   - other categories?
> 
> Select typical cases from each categories, analyze what went wrong in
> these cases, and try to identify practicable countermeasures.

No maintainer or no maintainer who is debugging bug reports is the 
major problem in all parts of your list.

> Another approach:  Figure out areas where quality is exemplary and try
> to draw conclusions for areas where quality is lacking.

ieee1394 has a maintainer who is looking after all bug reports he gets.

Conclusion: We need such maintainers for all parts of the kernel.

> Stefan Richter

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


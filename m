Return-Path: <linux-kernel-owner+w=401wt.eu-S1757624AbXGHXRI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624AbXGHXRI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 19:17:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751749AbXGHXQz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 19:16:55 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:54972 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751331AbXGHXQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 19:16:55 -0400
Date: Mon, 9 Jul 2007 01:17:26 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andi Kleen <ak@suse.de>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070708231726.GW3492@stusta.de>
References: <20070617214231.GA3588@stusta.de> <46760D87.2000502@goop.org> <20070708224444.GU3492@stusta.de> <200707090102.21784.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200707090102.21784.ak@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2007 at 01:02:21AM +0200, Andi Kleen wrote:
> On Monday 09 July 2007 00:44:44 Adrian Bunk wrote:
> > On Sun, Jun 17, 2007 at 09:43:51PM -0700, Jeremy Fitzhardinge wrote:
> > > Adrian Bunk wrote:
> > >...
> > > > Andi forwarded it although the following people had already NAK'ed it:
> > > > - Christoph Hellwig [1]
> > > > - Peter Zijlstra [2]
> > > > - Alan Cox [3]
> > > >
> > > > Considering that Andi forwarded it 2 days after he himself said a 
> > > > different solution was pending [4] I assume he mistakenly sent it for 
> > > > inclusion in your tree.
> > > >   
> > > 
> > > We played with some ideas, but they all turned out way too ugly to live. 
> > 
> > Andi got some NAK's, said himself it will be solved differently, and
> > two days later he submits the NAK'ed patch into Linus' tree.
> 
> It will be solved differently longer term, but short term the fix
> was still needed. There are limits on what can be done late 
> in the release cycle so simple patches win.

Your patch got into Linus' tree in the middle of the merge window...

> Besides none of the "NAK"s were particularly inspired in my opinion;
> there were no clear technical objections brought forward.

Why didn't you say this?

Your answer in [1] didn't sound as if you would submit this patch, and 
even less that you would submit it just two days later.

> -Andi

cu
Adrian

[1] http://lkml.org/lkml/2007/4/30/335

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


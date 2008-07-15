Return-Path: <linux-kernel-owner+w=401wt.eu-S932167AbYGOUng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932167AbYGOUng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 16:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYGOUn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 16:43:27 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:60936 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756192AbYGOUn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 16:43:26 -0400
Date: Tue, 15 Jul 2008 23:43:20 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, gorcunov@gmail.com,
       akpm@linux-foundation.org, mingo@elte.hu
Subject: Re: From 2.4 to 2.6 to 2.7?
Message-ID: <20080715204320.GJ24533@cs181140183.pp.htv.fi>
References: <6d291e080807141910m573b29b2t753ea7c4db09902d@mail.gmail.com> <alpine.LFD.1.10.0807141914280.3017@woody.linux-foundation.org> <6d291e080807141931g3080c94cic94f503c1a18523b@mail.gmail.com> <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807141939410.3017@woody.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 14, 2008 at 07:47:46PM -0700, Linus Torvalds wrote:
> 
> 
> On Mon, 14 Jul 2008, Stoyan Gaydarov wrote:
> > >
> > > For example, I don't see any individual feature that would merit a jump
> > > from 2.x to 3.x or even from 2.6.x to 2.8.x. So maybe those version jumps
> > > should be done by a time-based model too - matching how we actually do
> > > releases anyway.
> >
> > Does it have to be even numbers only?
> 
> No. But the even/odd thing is still so fresh in peoples memory (despite us 
> not having used it for years), and I think some projects aped us on it, so 
> if I didn't change the numbering setup, but just wanted to reset the minor 
> number, I'd probably jump from 2.6 to 2.8 just for historical reasons.
> 
> But I could also see the second number as being the "year", and 2008 would 
> get 2.8, and then next year I'd make the first release of 2009 be 2.9.1 
> (and probably avoid the ".0" just because it again has the connotations of 
> a "big new untested release", which is not true in a date-based numbering 
> scheme). And then 2010 would be 3.0.1 etc..
> 
> Anyway, I have to say that I personally don't have any hugely strong 
> opinions on the numbering. I suspect others do, though, and I'm almost 
> certain that this is an absolutely _perfect_ "bikeshed-painting" subject 
> where thousands of people will be very passionate and send me their 
> opinions on why _their_ particular shed color is so much better.
>...

The 2.6. prefix is like with X which is version 11 for 20 years and 
still counting.

Or like with X11R6, that became X11R7 after 11 years, there might be in 
a few years some big change that will warrant a 2.8 or 3.0 (the rewrite 
of the kernel in Visual Basic .NET ;-) ).

But my personal opinion is that we now have an established version 
numbering with the current development model that is 2.6.x, and users 
got used to it.

If you'd change it you will only create confusion - e.g. with your 2.9.1 
idea half the world will see that 9 is an odd number, remember the old 
kernel versioning, and think this is the first development release 
towards 3.0...

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


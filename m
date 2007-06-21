Return-Path: <linux-kernel-owner+w=401wt.eu-S1757314AbXFUN5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757314AbXFUN5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 09:57:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752474AbXFUN51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 09:57:27 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35409 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751433AbXFUN50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 09:57:26 -0400
Date: Thu, 21 Jun 2007 15:57:44 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Al Boldi <a1426z@gawab.com>
Cc: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: How to improve the quality of the kernel?
Message-ID: <20070621135744.GO12950@stusta.de>
References: <200706180141.41101.a1426z@gawab.com> <200706210626.20429.a1426z@gawab.com> <20070621130737.GN12950@stusta.de> <200706211641.28504.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200706211641.28504.a1426z@gawab.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 04:41:28PM +0300, Al Boldi wrote:
> Adrian Bunk wrote:
> > On Thu, Jun 21, 2007 at 06:26:20AM +0300, Al Boldi wrote:
> > > Adrian Bunk wrote:
> > > > We are talking about _tracking_.
> > > >
> > > > I'm not sure whether it makes much sense, and it would cost an
> > > > enormous amount of time, but tracking patches should be possible
> > > > without any knowledge of the kernel.
> > >
> > > If that's really true, which I can't imagine, then the proper way
> > > forward would probably involve a fully automated system.
> >
> > If you consider any kind of patch tracking valuable, you should either
> > do it yourself or write the tool yourself. In both cases, the
> > interesting parts would be how to integrate it into the workflow of
> > kernel development without creating extra work for anyone and how to get
> > the information into the got commits.
> 
> Integration is the easy part, really.  Just filter all the patches from the 
> mailing list into a patch-bin, then sort, categorize, and prioritize them, 
> responding with a validation status to all parties involved.
> 
> And after that comes the Tracking part.

Tracking shouldn't be much more than seeing what different threads are 
about the same patch and then do more or less the same as what you 
called "the easy part".

> > "requires a real PRO" and "would probably involve" sound like cheap
> > phrases for avoiding doing any work yourself.
> 
> I have learned from this list that premature involvement is 
> counterproductive.
> 
> > Talk is cheap, but unless YOU will do it your emails will only be a
> > waste of bandwidth.
> 
> Thanks, and good luck with involving people with this kind of response!

It's simply how kernel development works - not by talking but by doing 
the work.

Many people thought long-term maintainance for 2.6.16 wouldn't make sense.
And I didn't start long discussions whether we need regression tracking -
I simply did it.

These are things that simply happened because I thought they were 
important - and because I got my ass up to do them myself.

Don't expect anyone to jump up to do it only because of your talk.
YOU must offer something, and it will work if it's then accepted by 
people.

If you think what you have in mind is both doable and important just do it.
You will find out where the problems lie yourself.
You might be able to prove me and all other people who think it would 
not work wrong.
You might fail, e.g. because people will not adopt whatever you have in 
mind because they don't like it for some reason, but that's part of how 
development works, and you'll never know unless you try it.

> Al

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


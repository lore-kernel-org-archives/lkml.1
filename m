Return-Path: <linux-kernel-owner+w=401wt.eu-S1755558AbXFOPaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558AbXFOPaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752403AbXFOPaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:30:11 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59386 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750861AbXFOPaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:30:09 -0400
Date: Fri, 15 Jun 2007 08:29:14 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bernd Paysan <bernd.paysan@gmx.de>
cc: Theodore Tso <tytso@mit.edu>, Alexandre Oliva <aoliva@redhat.com>,
       Sean <seanlkml@sympatico.ca>, Adrian Bunk <bunk@stusta.de>,
       Valdis.Kletnieks@vt.edu, Daniel Hazelton <dhazelton@enter.net>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, david@lang.hm,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <200706151202.13708.bernd.paysan@gmx.de>
Message-ID: <alpine.LFD.0.98.0706150822050.14121@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0706141026150.14121@woody.linux-foundation.org>
 <orzm326s3w.fsf@oliva.athome.lsd.ic.unicamp.br> <20070615052432.GC14911@thunk.org>
 <200706151202.13708.bernd.paysan@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 15 Jun 2007, Bernd Paysan wrote:
> 
> Ah no, it's their fault. The GPLv2 always was clear that there will be some 
> future releases of the GPL, and that you should keep "upgrading" possible.

No. It is clear that you have the *option* of keep upgrading, but it is 
also equally clear that Linux has always decided *not* to exercise that 
option, exactly because I liked the GPLv2, not some "future upgrade".

I decided that long before I saw the GPLv3.

And I'm surprised by people who wonder why I did that.

I'm _intelligent_, dammit. That means that I can foresee the future to 
some degree, at least in the limited sense of what is a likely outcome of 
my actions.

Why are people surprised by the fact that I have foresight? I may be known 
for being an impolite bastard, but quite frankly, anybody who thinks I'm a 
_stupid_ impolite bastard must be missing a page.

You can disagree with my opinions. You can call me obstinate, impolite, 
and opinionated. But quite frankly, very few people have ever found me 
*stupid*.

So give me that - I'm not stupid. That means that I actually *can* predict 
the future to some fuzzy degree, and that people really should *not* be 
surprised by the fact that I never let the FSF control my choice of 
license.

> The GPLv2 tries hard to be compatible with any further versions of the GPL 
> as possible, by allowing people to choose which license you take, and by 
> making sure that no man in the middle can restrict this choice. If people 
> deliberately select to use "GPLv2 only", who's to blame?

There's no "blame". There's only credit.

Besides, you are wrong. The *default* for the GPLv2 in the presense of 
license information is *not* "v2 or later"

In order to get "GPLv2 or later", you actually have to explicitly specify 
it.

I just find it sad that so many people did that, often apparently just 
because they didn't actually read or understand the license.

		Linus

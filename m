Return-Path: <linux-kernel-owner+w=401wt.eu-S1757397AbXFMWHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757397AbXFMWHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 18:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbXFMWHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 18:07:22 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46019 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753323AbXFMWHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 18:07:20 -0400
Date: Wed, 13 Jun 2007 15:06:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Alexandre Oliva <aoliva@redhat.com>, Greg KH <greg@kroah.com>,
       debian developer <debiandev@gmail.com>, "david@lang.hm" <david@lang.hm>,
       Tarkan Erimer <tarkan@netone.net.tr>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
In-Reply-To: <20070613225743.42b80aef@the-village.bc.nu>
Message-ID: <alpine.LFD.0.98.0706131456230.14121@woody.linux-foundation.org>
References: <466A3EC6.6030706@netone.net.tr> <18026.16739.228277.938421@notabene.brown>
 <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr>
 <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr>
 <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm>
 <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com>
 <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
 <20070612184110.GB7980@kroah.com> <orir9smp3u.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131223051.14121@woody.linux-foundation.org>
 <or7iq7mx7f.fsf@oliva.athome.lsd.ic.unicamp.br>
 <alpine.LFD.0.98.0706131415090.14121@woody.linux-foundation.org>
 <20070613225743.42b80aef@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 13 Jun 2007, Alan Cox wrote:
>
> > find offensive, so I don't choose to use it. It's offensive because Tivo 
> > never did anything wrong, and the FSF even acknowledged that. The fact 
> 
> Not all of us agree with this for the benefit of future legal
> interpretation.

Well, even the FSF lawyers did, but one of the reasons I never wanted to 
do the copyright assignments(*) is exactly because I think people need to 
make their own judgments on what the GPLv2 means. In the end, the only 
thing that really matters is what a judge says (after appeals etc), and 
the fact is, any license will always have gray areas where people disagree 
about interpretation.

And I actually am of the very firm opinion that a world with gray areas 
(and purple, and pink, and green) is a hell of a lot better than one where 
everything is black-and-white. Only lawyers want a black-and-white world.

So I would actually *encourage* other people to sue over their GPLv2 
interpretations, as they have done in Germany (and as IBM has done in the 
US). I'd sue based on _my_ reading of it, but hey, while my opinion is 
obviously always correct, I recognize that I live in a world where not 
everybody else always sees that.

[ (*) Obviously, the *biggest* reason not to do copyright assignments is 
  that they are just a total pain in the ass to do, and cause tons of 
  totally pointless paperwork. So "Linus is lazy and not interested in 
  being a lawyer" is obviously the primary reason for the lack of 
  assignments. I'm just much happier with people owning their own code 
  outright. ]

Of course, I also realize that suing people over license violations is a 
big pain in the ass, and in that sense while I "encourage" people to 
assert their own copyrights, I would obviously also say that it's almost 
certainly not worth doing if it's in a "gray" area. But that, in the end, 
has to be the copyright owners own decision!

> > The GPLv2 is a *legal*license*. And no, the FSF doesn't get to define what 
> > the words mean to suit their agenda.
> 
> Agreed - everyone contributed to the kernel based upon the GPLv2. Lots of
> different reasons, lots of different viewpoints about GPL2 v  GPL3, DRM ,
> Treacherous Computing, etc. The commonality is not political, not a
> grand plan, not a grand unified social agenda but a bunch of people for
> whom the GPLv2 was an acceptable license for furthering their intentions
> whether that is education for all, a shared commons or just making a
> quick buck

Indeed. And it's _fine_ to even be in it "just to make a quick buck". We 
do want all kinds of input. I think the community is much healthier having 
lots of different reasons for people wanting to be involved, rather than 
concentrating on just some specific reason.

For some it's the technology. For some it's the license. For some it's 
just a thing to pass boredom. Others like to learn. Whatever. It's all 
good!

		Linus

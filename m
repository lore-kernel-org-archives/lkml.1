Return-Path: <linux-kernel-owner+w=401wt.eu-S1756958AbXFLSmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbXFLSmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2007 14:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756555AbXFLSly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jun 2007 14:41:54 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:37866 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756696AbXFLSlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2007 14:41:53 -0400
Date: Tue, 12 Jun 2007 11:41:10 -0700
From: Greg KH <greg@kroah.com>
To: debian developer <debiandev@gmail.com>
Cc: "david@lang.hm" <david@lang.hm>, Tarkan Erimer <tarkan@netone.net.tr>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@elte.hu
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070612184110.GB7980@kroah.com>
References: <466A3EC6.6030706@netone.net.tr> <18026.16739.228277.938421@notabene.brown> <20070609071231.GL2649@lug-owl.de> <466BB9B0.5030908@netone.net.tr> <Pine.LNX.4.64.0706100150080.6675@asgard.lang.hm> <466BCBBC.90305@netone.net.tr> <Pine.LNX.4.64.0706100301520.6675@asgard.lang.hm> <f24d23310706100355j3af7e12fq2e0e345402e48ca2@mail.gmail.com> <20070610160531.GA12179@kroah.com> <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f24d23310706121107y2ef218a4wc1c8f9a52fc9bdd7@mail.gmail.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2007 at 11:37:11PM +0530, debian developer wrote:
>  On 6/10/07, Greg KH <greg@kroah.com> wrote:
> > On Sun, Jun 10, 2007 at 04:25:55PM +0530, debian developer wrote:
> > >  On 6/10/07, david@lang.hm <david@lang.hm> wrote:
> > > > On Sun, 10 Jun 2007, Tarkan Erimer wrote:
> > > >
> > > > >> >  And maybe another questions should be : How long a copyright 
> > owner
> > > > can
> > > > >> >  hold the copyright, if died or lost for sometime ? if died, the
> > > > >> >  copyright still should be valid or not ? If lost, what the law 
> > orders
> > > > at
> > > > >> >  this point for copyright holding ?
> > > > >>
> > > > >>  I believe that in the US it's life + 90 years.
> > > > >>
> > > > >>  David Lang
> > > > > Hmm... Really,it is damn too much time to wait! It's really better 
> > idea
> > > > to
> > > > > replace the code of this person as said before instead of waiting 
> > such
> > > > 90+
> > > > > years!
> > > >
> > > > exactly, however as others are pointing out, there are a lot of active
> > > > developers who do not agree with some of the key points of the GPLv3
> > > > (including Linus), so until you convince them that the GPLv3 is better 
> > it
> > >
> > >  Last heard, Linus was quite impressed with the toned down version of
> > >  the final draft of GPLv3. I think Linus, and other major developers
> > >  should make their stand on this issue clear so that the kernel
> > >  community can discuss the future steps.
> >
> > "future steps"?  Hah.
> >
> > My code is going to stay GPLv2 as the v3 license is horrible for kernel
> > code for all of the reasons I have said in the past, plus a few more
> > (what, I can make an "industrial" product but not a commercial one?
> 
>      ^^^^^^^^^^^^^
>  What exactly in GPLv3 forbids you from making a commercial product?

Nothing "forbids" me, it's just the artifical distinstion of the two is,
in my opinion, stupid and foolish.  You are trying to define use-cases
to justify their notion that you must give up the hardware keys for one
type of device, yet not for another.

Even the people that feel that v2 says you need to give up the keys
think this is dumb.  But we've been through all of that before (see
previous long thread about v3 and why the kernel developers hate it, it
all still applys to the final draft.)

greg k-h

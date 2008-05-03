Return-Path: <linux-kernel-owner+w=401wt.eu-S1756111AbYECWI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111AbYECWI6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 18:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754727AbYECWIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 18:08:51 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33334 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315AbYECWIu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 18:08:50 -0400
Date: Sun, 4 May 2008 01:07:52 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503220752.GW5838@cs181133002.pp.htv.fi>
References: <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi> <20080503213822.GA24283@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20080503213822.GA24283@uranus.ravnborg.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2008 at 11:38:22PM +0200, Sam Ravnborg wrote:
> On Sun, May 04, 2008 at 12:24:29AM +0300, Adrian Bunk wrote:
> > On Sat, May 03, 2008 at 11:03:00PM +0200, Ingo Molnar wrote:
> > > 
> > > * Adrian Bunk <bunk@kernel.org> wrote:
> > >...
> > > > > As Sam said it, fixing that Kconfig design bug would be "nice" - but 
> > > > > unfortunately the Kconfig subsystem is not actively developed 
> > > > > anymore.
> > > > 
> > > > Roman is still active.
> > > 
> > > great, does this mean we'll see fixes for select's misbehavior, along 
> > > the lines of Sam's suggestions?
> > 
> > In the case of the problem here it would have turned one problem into 
> > another, and Roman's patch is the correct solution no matter whether 
> > you change the semantics of select or not.
> 
> Hi Adrian 
> It would be nice to know what was wrong with my suggestion.
> You have done your share of kconfig patches so you have a good grip
> on the problems we face.
> So any input on how we can improve kconfig so we can actually provide
> what people often expects or requests or need would be nice.
> 
> I have so far not done any hacking on the core of the backend of
> kconfig but if I one day find more than one hour in row where I can do
> some kernel stuff I may actually try it out.
> And then it would be nice to have a sketch ready how to solve the issues.
> 
> I would though request you to start a new mail thread for this and
> include both linux-kbuild@vger.kernel.org and Roman Zippel in the loop.

If you've sent a suggestion that included a description of the exact 
semantics you want to implement I must have missed it.

Can you send me a pointer or a description of the semantics?
I'll then have a look.

> 	Sam

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


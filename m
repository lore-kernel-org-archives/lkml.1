Return-Path: <linux-kernel-owner+w=401wt.eu-S1756294AbYECVjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294AbYECVjf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:39:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755636AbYECVin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:38:43 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:53109 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755542AbYECVia (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:38:30 -0400
Date: Sat, 3 May 2008 23:38:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080503213822.GA24283@uranus.ravnborg.org>
References: <20080430200340.GA13757@elte.hu> <20080430170125.ZZRA012@mailhub.coreip.homeip.net> <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503212429.GT5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 04, 2008 at 12:24:29AM +0300, Adrian Bunk wrote:
> On Sat, May 03, 2008 at 11:03:00PM +0200, Ingo Molnar wrote:
> > 
> > * Adrian Bunk <bunk@kernel.org> wrote:
> >...
> > > > As Sam said it, fixing that Kconfig design bug would be "nice" - but 
> > > > unfortunately the Kconfig subsystem is not actively developed 
> > > > anymore.
> > > 
> > > Roman is still active.
> > 
> > great, does this mean we'll see fixes for select's misbehavior, along 
> > the lines of Sam's suggestions?
> 
> In the case of the problem here it would have turned one problem into 
> another, and Roman's patch is the correct solution no matter whether 
> you change the semantics of select or not.

Hi Adrian 
It would be nice to know what was wrong with my suggestion.
You have done your share of kconfig patches so you have a good grip
on the problems we face.
So any input on how we can improve kconfig so we can actually provide
what people often expects or requests or need would be nice.

I have so far not done any hacking on the core of the backend of
kconfig but if I one day find more than one hour in row where I can do
some kernel stuff I may actually try it out.
And then it would be nice to have a sketch ready how to solve the issues.

I would though request you to start a new mail thread for this and
include both linux-kbuild@vger.kernel.org and Roman Zippel in the loop.

	Sam

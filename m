Return-Path: <linux-kernel-owner+w=401wt.eu-S1754722AbYEDHfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754722AbYEDHfr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 03:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbYEDHfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 03:35:40 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:37824 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbYEDHfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 03:35:39 -0400
Date: Sun, 4 May 2008 09:36:14 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Ingo, no more kconfig patches
Message-ID: <20080504073614.GA16289@uranus.ravnborg.org>
References: <20080430211317.GA24633@elte.hu> <20080430230100.GK29330@cs181133002.pp.htv.fi> <20080501025234.GE27574@elte.hu> <20080501115923.GX29330@cs181133002.pp.htv.fi> <20080503191445.GF5292@elte.hu> <20080503202416.GR5838@cs181133002.pp.htv.fi> <20080503210300.GA10979@elte.hu> <20080503212429.GT5838@cs181133002.pp.htv.fi> <20080503213822.GA24283@uranus.ravnborg.org> <20080503220752.GW5838@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080503220752.GW5838@cs181133002.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Hi Adrian 
> > It would be nice to know what was wrong with my suggestion.
> > You have done your share of kconfig patches so you have a good grip
> > on the problems we face.
> > So any input on how we can improve kconfig so we can actually provide
> > what people often expects or requests or need would be nice.
> > 
> > I have so far not done any hacking on the core of the backend of
> > kconfig but if I one day find more than one hour in row where I can do
> > some kernel stuff I may actually try it out.
> > And then it would be nice to have a sketch ready how to solve the issues.
> > 
> > I would though request you to start a new mail thread for this and
> > include both linux-kbuild@vger.kernel.org and Roman Zippel in the loop.
> 
> If you've sent a suggestion that included a description of the exact 
> semantics you want to implement I must have missed it.
> 
> Can you send me a pointer or a description of the semantics?
> I'll then have a look.

I took the original idea and added a few more details.
Please see mail named "http://lkml.org/lkml/2008/5/4/18"
http://lkml.org/lkml/2008/5/4/18

	Sam

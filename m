Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbXFQOss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbXFQOss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 10:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXFQOsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 10:48:41 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37516 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751564AbXFQOsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 10:48:40 -0400
Date: Sun, 17 Jun 2007 16:48:55 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] (Re: regression tracking (Re: Linux 2.6.21))
Message-ID: <20070617144855.GX3588@stusta.de>
References: <alpine.LFD.0.98.0704291049060.9964@woody.linux-foundation.org> <6bffcb0e0706170322j3c51868fn6189bfd7d3bcac1@mail.gmail.com> <20070617114709.GD16016@flower.upol.cz> <200706171413.40890.rjw@sisk.pl> <20070617142430.GF16016@flower.upol.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070617142430.GF16016@flower.upol.cz>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 17, 2007 at 04:24:30PM +0200, Oleg Verych wrote:
> On Sun, Jun 17, 2007 at 02:13:39PM +0200, Rafael J. Wysocki wrote:
> > On Sunday, 17 June 2007 13:47, Oleg Verych wrote:
> []
> > > It's OK _only_ in case of unknown, hard to find *hardware* bugs.
> > > 
> > > If you think it's "a good thing" for bad, untested by developer
> > > code, then something is completely wrong.
> > 
> > Oh, I've just fixed two purely software bugs pointed out by binary searching
> > in the code that I'm sure has been tested, not only by its developers, but the
> > bugs only showed up in my configuration (on one out of four test boxes).
> > 
> > There are so many different kernel configurations possible that there's no way
> > a developer can test them all.
> 
> With current state of affairs it's not only hard for developers, but
> and for users: <20070221220520.GA20659@artselect.com>,
>               <20070429230037.95120@gmx.net>

Uwe has an attitude that made many people (including Linus himself) 
set their mail filters to deliver his emails directly to /dev/null.

Parts of the contents of his emails were usable including usable 
regression reports - but the way he treats people simply disqualified 
him.

> I'm trying to re-do some kbuild stuff, but i'm getting rather offensive
> answers :( <1182020654.8176.398.camel@chaos>
>...

I'm not seeing anything in Thomas' email that could be considered 
offensive. He told you in a technical way why he disagrees with you.

If you call this email "rather offensive", you should _really_ 
unsubscribe from lkml (or even any Debian mailing lists). And this is 
not meant against you, it's simply that for the standards of lkml there 
is nothing offensive in this email.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


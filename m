Return-Path: <linux-kernel-owner+w=401wt.eu-S1763774AbXG0ScT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763774AbXG0ScT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 14:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758416AbXG0ScM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 14:32:12 -0400
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:35016
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758394AbXG0ScL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 14:32:11 -0400
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Date: Fri, 27 Jul 2007 14:32:07 -0400
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
References: <1184980678.6344.1.camel@localhost.localdomain> <200707251822.54745.rob@landley.net> <1185420922.27447.19.camel@localhost.localdomain>
In-Reply-To: <1185420922.27447.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707271432.07748.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 July 2007 11:35:22 pm Rusty Russell wrote:
> On Wed, 2007-07-25 at 18:22 -0400, Rob Landley wrote:
> > On Monday 23 July 2007 9:01:48 pm Rusty Russell wrote:
> > > > IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
> > > > please.
> > >
> > > So they can see what we're talking about, here's an example of the
> > > output:
> > >
> > > 	http://lguest.ozlabs.org/lguest-journey.c.bz2
> >
> > Er, so you read the readme, and then you type "make Preparation!" (which
> > I wouldn't have guessed from the comment at the end of the readme), and
> > it spits this to stdout.
>
> Hi Rob!
>
> 	I'm going to ask an odd thing.  I *don't* think this should be part of
> the generally-available kernel documentation.  I'm sure you can see
> several reasons for this, but I'll spell them out for posterity.

Actually I don't see, but I'll respect the author's wishes when they don't 
want something indexed.

> 	People reading the lguest *code* documentation should feel a sense of
> achievement.

There are a number of areas of the kernel that give a deep sense of 
achievement upon figuring out what the heck is going on.  This includes 
theoretically documented ones, like the SCSI layer, which I'm working on but 
it makes my little brain hurt.

(Of course my brain hurts _more_ after reading yesterday's email from James 
Bottomley politely and thoroughly answering my first round of questions, but 
I now have a whole new mailing list to bother.  The fact I'm moving back to 
Austin this weekend and have to go pack a truck kind of screws up the 
scheduling of this, but I'll get back to making my brain hurt next week.)

> It starts with a slight puzzle, works its way through deep 
> details of code, and emerges with the reader feeling confident enough to
> start hacking on it.
>
> Thanks for your understanding!

Er, you're welcome?

> Rusty.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

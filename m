Return-Path: <linux-kernel-owner+w=401wt.eu-S1762027AbXGZDfl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762027AbXGZDfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 23:35:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757458AbXGZDfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 23:35:34 -0400
Received: from ozlabs.org ([203.10.76.45]:55274 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875AbXGZDfd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 23:35:33 -0400
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       virtualization <virtualization@lists.linux-foundation.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>
In-Reply-To: <200707251822.54745.rob@landley.net>
References: <1184980678.6344.1.camel@localhost.localdomain>
	 <20070723171238.1a832b31.akpm@linux-foundation.org>
	 <1185238908.1803.63.camel@localhost.localdomain>
	 <200707251822.54745.rob@landley.net>
Content-Type: text/plain
Date: Thu, 26 Jul 2007 13:35:22 +1000
Message-Id: <1185420922.27447.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-25 at 18:22 -0400, Rob Landley wrote:
> On Monday 23 July 2007 9:01:48 pm Rusty Russell wrote:
> > > IOW, I'd be interested in hearing Rob and Randy's opinions on it all,
> > > please.
> >
> > So they can see what we're talking about, here's an example of the
> > output:
> >
> > 	http://lguest.ozlabs.org/lguest-journey.c.bz2
> 
> Er, so you read the readme, and then you type "make Preparation!" (which I 
> wouldn't have guessed from the comment at the end of the readme), and it 
> spits this to stdout.

Hi Rob!

	I'm going to ask an odd thing.  I *don't* think this should be part of
the generally-available kernel documentation.  I'm sure you can see
several reasons for this, but I'll spell them out for posterity.

	People reading the lguest *code* documentation should feel a sense of
achievement.  It starts with a slight puzzle, works its way through deep
details of code, and emerges with the reader feeling confident enough to
start hacking on it.

Thanks for your understanding!
Rusty.



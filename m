Return-Path: <linux-kernel-owner+w=401wt.eu-S1753134AbXCRIEO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134AbXCRIEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 04:04:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753137AbXCRIEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 04:04:13 -0400
Received: from mail.gmx.net ([213.165.64.20]:53600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753134AbXCRIEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 04:04:11 -0400
X-Provags-ID: V01U2FsdGVkX18BKqQSbHMByuRWwLHymA6wxmc9Bnb/plx0hV/fmS
	pRX3871vTN8luy
Subject: Re: [ck] Re: RSDL v0.31
From: Mike Galbraith <efault@gmx.de>
To: Radoslaw Szkodzinski <astralstorm@gmail.com>
Cc: Kasper Sandberg <lkml@metanurb.dk>, Al Boldi <a1426z@gawab.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       ck@vds.kolivas.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Nicholas Miell <nmiell@comcast.net>
In-Reply-To: <1174203482.8855.8.camel@Homer.simpson.net>
References: <200703042335.26785.a1426z@gawab.com>
	 <200703172048.46267.kernel@kolivas.org>
	 <1174125534.7734.2.camel@Homer.simpson.net>
	 <200703172355.30989.a1426z@gawab.com>
	 <1174198651.8199.44.camel@Homer.simpson.net>
	 <1174200463.10498.23.camel@localhost>
	 <1174201726.8732.6.camel@Homer.simpson.net>
	 <f44c5fdf0703180022n44b2ca61o62602e54aaab3334@mail.gmail.com>
	 <1174203482.8855.8.camel@Homer.simpson.net>
Content-Type: text/plain
Date: Sun, 18 Mar 2007 09:04:10 +0100
Message-Id: <1174205050.8855.12.camel@Homer.simpson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-03-18 at 08:38 +0100, Mike Galbraith wrote:
> On Sun, 2007-03-18 at 08:22 +0100, Radoslaw Szkodzinski wrote:
> 
> > I'd recon KDE regresses because of kioslaves waiting on a pipe
> > (communication with the app they're doing IO for) and then expiring.
> > That's why splitting IO from an app isn't exactly smart. It should at
> > least be ran in an another thread.
> 
> Hm.  Sounds rather a lot like the...
> X sucks, fix X and RSDL will rock your world.  RSDL is perfect.
> ...that I've been getting.

P.S.  For those folks who appear to think that I'm in love with mainline
behavior and blissfully ignorant of it's shortcomings.

http://lwn.net/Articles/176635/


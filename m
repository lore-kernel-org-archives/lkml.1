Return-Path: <linux-kernel-owner+w=401wt.eu-S1753317AbXCRJ5q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317AbXCRJ5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2007 05:57:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbXCRJ5q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Mar 2007 05:57:46 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:54759 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbXCRJ5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2007 05:57:45 -0400
Subject: Re: [ck] Re: RSDL v0.31
From: Kasper Sandberg <lkml@metanurb.dk>
To: Mike Galbraith <efault@gmx.de>
Cc: Radoslaw Szkodzinski <astralstorm@gmail.com>, Al Boldi <a1426z@gawab.com>,
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
Date: Sun, 18 Mar 2007 10:57:33 +0100
Message-Id: <1174211853.10498.25.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
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
> 
not really, only X sucks. KDE works atleast as good with rsdl as
vanilla. i dont know how originally said kde works worse, wasnt it just
someone that thought?

> 	-Mike
> 
> 


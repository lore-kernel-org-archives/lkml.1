Return-Path: <linux-kernel-owner+w=401wt.eu-S1762937AbXGUK4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762937AbXGUK4F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 06:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758957AbXGUKz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 06:55:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:38381 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758285AbXGUKz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 06:55:56 -0400
Date: Sat, 21 Jul 2007 12:56:11 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH -mm 0/5] Freezer update
Message-ID: <20070721105611.GF1902@elf.ucw.cz>
References: <200707180929.31511.rjw@sisk.pl> <20070718010353.27965df7.akpm@linux-foundation.org> <200707181044.15662.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707181044.15662.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > The patches in these series update the freezer to eliminate some existing
> > > shortcomings,
> > 
> > argh.
> > 
> > I have a backlog of maybe 300 patches here which I am cheerfully ignoring
> > while concentrating on preventing 2.6.23 from being less of a disaster than
> > it has already been.
> > 
> > Please, stop writing patches.  Maybe do something to help get 2.6.23 off
> > its back.  Like, go review some of the code which people are cheerfully
> > merging five minutes after having written it.
> > 
> > > so please consider them as 2.6.23 material.
> > 
> > The door for new 2.6.23 material shut two weeks ago.  Here, at least.
> > 
> > Later, OK?
> 
> OK, and sorry for the trouble.

Actually, 1 and 2 from that series seem like .23 material to me. 1 is
(harmless docs update, and 2 is trivial bugfix for fuse.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

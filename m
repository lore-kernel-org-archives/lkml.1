Return-Path: <linux-kernel-owner+w=401wt.eu-S932133AbYENO4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133AbYENO4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 10:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762961AbYENOzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 10:55:46 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:51531 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762949AbYENOzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 10:55:45 -0400
Date: Wed, 14 May 2008 16:55:26 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, davem@davemloft.net, linux-kernel@vger.kernel.org,
       jirislaby@gmail.com
Subject: Re: Slow DOWN, please!!!
Message-ID: <20080514145526.GB6569@ucw.cz>
References: <20080429.190352.137408408.davem@davemloft.net> <200804302245.50817.rjw@sisk.pl> <alpine.LFD.1.10.0804301422350.2980@woody.linux-foundation.org> <200805010023.32213.rjw@sisk.pl> <alpine.LFD.1.10.0804301530360.2980@woody.linux-foundation.org> <20080430154124.7ec08dd4.akpm@linux-foundation.org> <20080501005727.GO29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301821380.5994@woody.linux-foundation.org> <20080501021327.GS29330@cs181133002.pp.htv.fi> <alpine.LFD.1.10.0804301919080.5994@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804301919080.5994@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > I am saying that it was merged too early, and that there are points that 
> > should have been addressed before the driver got merged.
> > 
> > Get it submitted for review to linux-kernel.
> > Give the maintainers some time to incorporate all comments.
> > Even one month later it could still have made it into 2.6.25.
> > 
> > The only problem with my suggestion is that it's currently pretty random 
> > whether someone takes the time to review such a driver on linux-kernel.
> 
> Now, I do agree that we could/should have some more process in general. I 
> really _would_ like to have a process in place that basically says:
> 
>  - everything must have gone through lkml at least once


What about 'must go through lkml at least once *outside the merge
window*'. Or is it just me?

 During the merge window, I'm totally overloaded by all those patches
going in and related lkml traffic...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S932754AbYDYUvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932754AbYDYUvV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 16:51:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760954AbYDYUvM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 16:51:12 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:35883 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759490AbYDYUvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 16:51:12 -0400
Date: Fri, 25 Apr 2008 22:51:51 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Paul Walmsley <paul@pwsan.com>, Dmitry <dbaryshkov@gmail.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       David Brownell <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080425205151.GA6251@elf.ucw.cz>
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com> <20080425103942.GC14903@elf.ucw.cz> <20080425202010.GA28893@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425202010.GA28893@flint.arm.linux.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > WTF? There are currently around 10 copies of clock code in the tree,
> > every one slightly different. If this can help us get rid of all that
> > crap, that's a GOOD THING, normative or not.
> 
> At the expense of people going off and inventing their own APIs because
> they find that the "normatived" clock API doesn't do what they need to?

Just now, everyone just cuts&copies clock.c. I do not think "new"
situation can worse than that.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

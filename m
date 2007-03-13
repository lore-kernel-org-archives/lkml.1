Return-Path: <linux-kernel-owner+w=401wt.eu-S933106AbXCMUFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933106AbXCMUFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 16:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933094AbXCMUFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 16:05:51 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45025 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933121AbXCMUFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 16:05:50 -0400
Date: Tue, 13 Mar 2007 21:05:42 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: Oliver Neukum <oneukum@suse.de>, Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [1/6] 2.6.21-rc3: known regressions
Message-ID: <20070313200542.GC12370@elf.ucw.cz>
References: <Pine.LNX.4.64.0703062050570.5963@woody.linux-foundation.org> <20070313124957.GR18731@stusta.de> <45F6A240.3090601@drzeus.cx> <200703131436.15586.oneukum@suse.de> <20070313181147.GA12224@elf.ucw.cz> <45F6F677.1070302@drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F6F677.1070302@drzeus.cx>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > Uhuh. User error, lets close the report.
> > 
> > mmc changed the major to 
> > 
> > 236 mmc
> > 
> > ... while it was something else in 2.6.20. Can we get stable device
> > allocation for mmc?
> 
> What kind of savages do not use udev these days?! ;)
> 
> I don't have the time and energy to jump through all the hoops required to get
> an official number right now. Most users use udev and those that don't can use
> the "major" parameter for mmc_block.

That's okay, but if one of those savages got major for you, would you
be willing to use it? :-).
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

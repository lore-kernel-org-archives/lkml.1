Return-Path: <linux-kernel-owner+w=401wt.eu-S936904AbXFGVPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936904AbXFGVPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:15:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760569AbXFGVO5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:14:57 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:41930 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755239AbXFGVO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:14:56 -0400
Date: Thu, 7 Jun 2007 23:14:37 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Gene Heskett <gene.heskett@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.22-rc4
Message-ID: <20070607211437.GA8611@elf.ucw.cz>
References: <alpine.LFD.0.98.0706042040350.23741@woody.linux-foundation.org> <200706071206.06298.gene.heskett@gmail.com> <Pine.LNX.4.64.0706071853080.15778@fbirervta.pbzchgretzou.qr> <200706071621.00687.gene.heskett@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200706071621.00687.gene.heskett@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Don't know Jan.  nv, the last time I tried that bucket of molasses in january, 
> couldn't drive this card at more than 800x600, and I am used to double that 
> both ways.
> 
> The last time I booted to nv, it took me a week to get all the crap fixed that 
> it overwrote trying to fit the default screens I use while trying to make 
> them fit in an 800x600 window.
> 
> I run 1600x1200, on either an ati card (but the radeon driver quit supporting  
> the r280 chipset according to boot messages, the main reason I bought this 
> nvidia card) or on an older nvidia card that nv was quite happy with.  That 
> card went belly up and took the motherboard with it 2 years ago though.
> 
> Did you miss the comment that it works with a 2.6.21ish kernel?  Everything 
> else being equal.  I will boot to one of them later tonight and test it to 
> make sure its not some update to kde though, and let the list know.

Well, your kernel is tainted with nvidia crap we are not allowed to
debug. Issue is screen blanking. "It worked before" or not is not
really interesting, sorry.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

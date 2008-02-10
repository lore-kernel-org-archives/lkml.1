Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYBJVDJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYBJVDJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 16:03:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755556AbYBJVCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 16:02:48 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:39883 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755417AbYBJVCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 16:02:47 -0500
Date: Sun, 10 Feb 2008 22:02:58 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Brownell <david-b@pacbell.net>, linux-pm@lists.linux-foundation.org,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] sleepy linux self-test
Message-ID: <20080210210258.GH15662@elf.ucw.cz>
References: <20080130131748.GA3796@elf.ucw.cz> <20080202193202.GB31621@elf.ucw.cz> <20080202193843.GB32039@elte.hu> <200802021837.17777.david-b@pacbell.net> <20080203050537.GA18942@elte.hu> <20080203051425.GA20740@elte.hu> <20080203051953.GA21183@elte.hu> <20080203053507.GA21681@elte.hu> <20080203055429.GA24996@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203055429.GA24996@elte.hu>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> >  [   23.893598] Calling initcall 0xc0c518b0: be_sleepy+0x0/0x170()
> >  [   23.901601] PM: no wakelarm-capable RTC
> >  [   23.905599] initcall 0xc0c518b0: be_sleepy+0x0/0x170() returned 0.
> >  [   23.910879] initcall 0xc0c518b0 ran for 3 msecs: be_sleepy+0x0/0x170()
> > 
> > so close, yet so far away :-)
> 
> good news: the suspend+resume self-test works perfectly now! :-)

Good. What's next here? Will you just merge it to -x86, meaning it is
planned for 2.6.26?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

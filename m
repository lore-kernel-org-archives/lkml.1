Return-Path: <linux-kernel-owner+w=401wt.eu-S1752331AbXBDNf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbXBDNf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 08:35:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752335AbXBDNf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 08:35:26 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:42588 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752332AbXBDNf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 08:35:26 -0500
Date: Sun, 4 Feb 2007 14:35:19 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Casper Bruun <casperbruun@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Battery life on Lenovo X60s
Message-ID: <20070204133519.GA2028@elf.ucw.cz>
References: <811fe5c70702031134r598171c9mee978fba22e2e3f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <811fe5c70702031134r598171c9mee978fba22e2e3f2@mail.gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I and many others are having problems with battery life on the Lenovo
> X60s laptop.
> 
> There have been several threads concerning this on Nabble, thinkwiki
> and many other Linux sites, and the problem has always been the same:
> Linux draw significantly more power than XP on this particular
> laptop.

You did not do your research. I had "8 hours on your lap[top]"
presentation, exactly about thinkpad x60.

Solve any cpu frequency scaling problems you may have... then unload
usb. If you want to be fancy, ask Tejun for SATA powersave stuff...

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

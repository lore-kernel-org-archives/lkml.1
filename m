Return-Path: <linux-kernel-owner+w=401wt.eu-S933339AbZHVTf1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbZHVTf1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 15:35:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933312AbZHVTf0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 15:35:26 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:44335 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309AbZHVTf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 15:35:26 -0400
Date: Sat, 22 Aug 2009 21:35:15 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Felipe Balbi <me@felipebalbi.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mike Rapoport <mike@compulab.co.il>, linux-kernel@vger.kernel.org
Subject: Re: Smart Battery System Design (was: Re: Question about
	userspace-consumer)
Message-ID: <20090822193515.GA15488@elf.ucw.cz>
References: <20090811204914.GB13969@gandalf> <20090811223645.GA4691@sirena.org.uk> <20090814163201.GB1626@ucw.cz> <20090815164324.GA4252@sirena.org.uk> <20090815223434.GB27637@elf.ucw.cz> <20090816091858.GB12567@sirena.org.uk> <20090822092845.GE11448@elf.ucw.cz> <20090822101641.GC4344@sirena.org.uk> <20090821140126.GA1328@ucw.cz> <20090822141646.GA5812@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090822141646.GA5812@sirena.org.uk>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > Like you say this is a very old design but even there I'm fairly
> > > surprised it's causing issues when charging from a wall supply.  If
> > > you're charging from USB then there is obviously a constraint on the
> > > power draw but normally a modern system has sufficiently low power draw
> > > when idle that it's not actually a big deal - runtime power management
> > > facilities have improved greatly.
> 
> > Well... all the hardware I have here (zaurus, openmoko, htc dream) has
> > issues with power consumption while charging... so I do not think
> > runtime pm is solved problem.
> 
> The Zaurus and OpenMoko aren't exactly modern designs.  The Dream does
> surprise me, though.  I can't find any references to issues with this -
> any pointers?  If the phone were actually in use I'd expect it to have
> trouble charging off USB but sitting idle it's a lot more surprising,
> especially running Android.

Well, I'd like the older designs to work well too. (Actually, the
Dream... was on wifi when I got bad problems charging it from
usb.... so maybe charging while suspended would not help there).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

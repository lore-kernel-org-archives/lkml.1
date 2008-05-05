Return-Path: <linux-kernel-owner+w=401wt.eu-S1752608AbYEEH7G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608AbYEEH7G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 03:59:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754780AbYEEH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 03:58:48 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:46332 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754658AbYEEH6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 03:58:47 -0400
Date: Mon, 5 May 2008 09:59:35 +0200
From: Pavel Machek <pavel@suse.cz>
To: Paul Walmsley <paul@pwsan.com>
Cc: Dmitry <dbaryshkov@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       pHilipp Zabel <philipp.zabel@gmail.com>, tony@atomide.com,
       David Brownell <david-b@pacbell.net>, hiroshi.DOYU@nokia.com
Subject: Re: [PATCH 0/5] Clocklib: generic clocks framework
Message-ID: <20080505075935.GB10819@elf.ucw.cz>
References: <20080420082925.GA32739@doriath.ww600.siemens.net> <alpine.DEB.1.00.0804210057000.17857@utopia.booyaka.com> <bc64b4640804210148p2d1c2fe0qe469152fa1a9697e@mail.gmail.com> <alpine.DEB.1.00.0804250221040.14755@utopia.booyaka.com> <bc64b4640804260147o70253917me32b0e35a1ce6ad8@mail.gmail.com> <alpine.DEB.1.00.0805012221220.7405@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0805012221220.7405@utopia.booyaka.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > 2) to drop lots of copies of nearly the same code.
> 
> I don't really see much of a problem with the current situation, as long 
> as all of the implementations use the same interface.  Right now, 

There's no "same interface". The interface looks similar on the
surface, but it seems mach-* maintainers can (and do) hack it as they
see fit.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

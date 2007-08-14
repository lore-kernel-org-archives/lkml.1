Return-Path: <linux-kernel-owner+w=401wt.eu-S1760248AbXHNLnr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760248AbXHNLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:43:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756393AbXHNLn3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:43:29 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56052 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755947AbXHNLn2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:43:28 -0400
Date: Tue, 14 Aug 2007 09:05:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joe Perches <joe@perches.com>, torvalds@linux-foundation.org,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [443/2many] MAINTAINERS - HIBERNATION (aka Software Suspend, aka swsusp):
Message-ID: <20070814070528.GA2903@elf.ucw.cz>
References: <46bffbd3.IqsNHrHU1Y9BF7Dd%joe@perches.com> <200708132325.04810.rjw@sisk.pl> <1187040080.10249.323.camel@localhost> <200708132338.25925.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708132338.25925.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > + include/linux/suspend.h
> > > + include/linux/freezer.h
> > > + include/linux/pm.h
> > > + include/asm-*/suspend.h
> > > 
> > > Hm, they are also relevant for suspend to RAM, so perhaps one common
> > > list of files for suspend to RAM and hibernation would be better?
> > 
> > Maybe just collapse the 2 maintainers blocks into one?

No, please don't.

> > HIBERNATION (aka Software Suspend, aka swsusp) and SUSPEND TO RAM:
> > P:	Pavel Machek
> > M:	pavel@suse.cz
> > P:	Rafael J. Wysocki
> > M:	rjw@sisk.pl
> > L:	linux-pm@lists.linux-foundation.org
> > S:	Supported
> 
> Then I think it should be "Maintained".

No, supported is still right :-).
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

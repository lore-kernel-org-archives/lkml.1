Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXEaOYP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXEaOYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 10:24:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXEaOYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 10:24:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:49255 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752044AbXEaOYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 10:24:00 -0400
Date: Thu, 31 May 2007 16:23:57 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: nigel@nigel.suspend2.net, Alan Stern <stern@rowland.harvard.edu>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Oliver Neukum <oliver@neukum.org>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Message-ID: <20070531142357.GK27309@elf.ucw.cz>
References: <Pine.LNX.4.44L0.0705281155270.22682-100000@netrider.rowland.org> <200705302311.40123.rjw@sisk.pl> <1180563897.6777.11.camel@nigel.suspend2.net> <200705310744.44488.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705310744.44488.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > I'll post revised patches in a new thread.
> > 
> > I haven't been giving this much attention, so forgive me if I'm about to
> > ask a silly question... which notifiers would you see the avenrun
> > saving/restoring using?
> 
> I'm not sure what you mean.  Could you please clarify?

Remember that patch about saving/restoring "load average"? I guess
Nigel asks where to hook it.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

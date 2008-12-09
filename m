Return-Path: <linux-kernel-owner+w=401wt.eu-S1753710AbYLIMlA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbYLIMlA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 07:41:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751914AbYLIMkv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 07:40:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:47310 "EHLO
	gprs189-60.eurotel.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbYLIMku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 07:40:50 -0500
Date: Tue, 9 Dec 2008 13:40:41 +0100
From: Pavel Machek <pavel@suse.cz>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: kernel list <linux-kernel@vger.kernel.org>, mtk.manpages@gmail.com,
       dl9pf@gmx.de, rdunlap@xenotime.net, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Document sysfs interface to RTC system wakeup
Message-ID: <20081209124040.GB1547@ucw.cz>
References: <20081126161524.GD1983@elf.ucw.cz> <9b2b86520811260959u633903f5o570a97ea83369f7c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b2b86520811260959u633903f5o570a97ea83369f7c@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +tino.keitel@gmx.de
> > +
> 
> It's unclear what the purpose of this email address is :).
> 
> <snip>
> 
> > +cd /proc/acpi
> > +echo EXP0 > wakeup
> > +echo PCI1 > wakeup
> > +echo USB0 > wakeup
> > +echo USB1 > wakeup
> > +echo USB2 > wakeup
> > +echo USB7 > wakeup
> > +echo HDEF > wakeup
> 
> Can you add a comment before this block, something like
> 
> # Toggle example wakeup devices
> # "cat wakeup" will show the list of devices on your specific system,
> and their current state

Thanks for the comments. I'd apply them and spin new version.
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

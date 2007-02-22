Return-Path: <linux-kernel-owner+w=401wt.eu-S1751811AbXBVT5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811AbXBVT5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 14:57:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751806AbXBVT5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 14:57:34 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3871 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751807AbXBVT5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 14:57:32 -0500
Date: Thu, 22 Feb 2007 15:53:57 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Len Brown <lenb@kernel.org>
Cc: tony.luck@intel.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org,
       "Accardi, Kristen" <kristen.c.accardi@intel.com>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.21
Message-ID: <20070222155357.GA4692@ucw.cz>
References: <200702071418.51058.lenb@kernel.org> <20070209230928.GD3949@ucw.cz> <200702092327.04237.lenb@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702092327.04237.lenb@kernel.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > the old /proc/acpi/ interfaces with cleaner interfaces in sysfs --
> > > non-ACPI-specific generic ones whenever possible.  This effort
> > > is not complete, but it has been in -mm for a long time and
> > > I believe that it is time to push it upstream to benefit
> > > from broader exposure and testing.
> > 
> > Does it still include completely broken alarm interface? Can't find it
> > in changelogs, so hopefully not.
> 
> No. See discussion on linux-acpi.
> David Brownell's RTC driver will provide the new RTC interface in sysfs.
> /proc/acpi/alarm will go away when the rest of /proc/acpi goes away.

I guess I should say 'sorry for a flame'. I've seen a discussion
(linux-pm or somewhere), but did not see the decision to drop the
offending patch.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

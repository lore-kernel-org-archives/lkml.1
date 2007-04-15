Return-Path: <linux-kernel-owner+w=401wt.eu-S1750977AbXDOKXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750977AbXDOKXl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 06:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbXDOKXl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 06:23:41 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:3579 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750977AbXDOKXj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 06:23:39 -0400
Date: Sun, 15 Apr 2007 10:23:28 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH][RFC] Kill off legacy power management stuff.
Message-ID: <20070415102328.GA11021@ucw.cz>
References: <Pine.LNX.4.64.0704122025380.3628@CPE00045a9c397f-CM001225dbafb6> <200704131022.45315.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704131022.45315.rjw@sisk.pl>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > just something i threw together, not in final form, but it represents
> > tossing the legacy PM stuff.  at the moment, the menuconfig entry for
> > PM_LEGACY lists it as "DEPRECATED", while the help screen calls it
> > "obsolete."  that's a good sign that it's getting close to the time
> > for it to go, and the removal is fairly straightforward, but there's
> > no mention of its removal in the feature removal schedule file.

Yes, it will be nice to see this old code be gone.

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

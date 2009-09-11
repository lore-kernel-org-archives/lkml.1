Return-Path: <linux-kernel-owner+w=401wt.eu-S1754451AbZIKQNk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754451AbZIKQNk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 12:13:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752179AbZIKQNk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 12:13:40 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:58331 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234AbZIKQNj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 12:13:39 -0400
Date: Fri, 11 Sep 2009 18:13:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: arve@android.com, swetland@google.com,
       kernel list <linux-kernel@vger.kernel.org>
Subject: Re: newer version of HTC Dream support
Message-ID: <20090911161335.GA8137@elf.ucw.cz>
References: <20090824092204.GB25591@elf.ucw.cz> <20090901131832.GA1835@ucw.cz> <20090904090303.024e981a.randy.dunlap@oracle.com> <20090911071155.GA1386@ucw.cz> <20090911075847.2fb7210a.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090911075847.2fb7210a.randy.dunlap@oracle.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > > With 2.6.31 being closer... is there a git tree or set of patches to
> > > > > make it boot on HTC Dream?
> > > > > 
> > > > > Quite a lot of hw should be supported in linux-next, and it would be
> > > > > nice to get arch-specific code working with linux-next and eventually
> > > > > merged...
> > > > 
> > > > Any news here? If you need some more kernel hackers I guess I'm
> > > > looking for a job :-).
> > > 
> > > well, mmotm and linux-next dream builds fail like this:
> > 
> > Ok, is the goal here to get it to compile, or get it to boot?
> 
> Can you do b. (boot) without a. (compile)?

Well, hardly, but I can do a) without b), and it is very much
easier. So... which is it?

> > I have recent tree that compiles, somewhere, but getting it to boot is
> > 'slightly more interesting'.
> 
> Sure, booting is more interesting.  Especially if one has the device.

Do you have one?

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbXHNLqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbXHNLqU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760178AbXHNLno
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:43:44 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:56066 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759564AbXHNLnm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:43:42 -0400
Date: Tue, 14 Aug 2007 12:09:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Norbert Preining <preining@logic.at>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Olaf Dietsche <olaf+list.linux-acpi@olafdietsche.de>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.22-rc3][ACPI?] Resume from s2r doesn't work.
Message-ID: <20070814100914.GE2900@elf.ucw.cz>
References: <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz> <20070613173925.GA20628@gamma.logic.tuwien.ac.at> <200706132342.55336.rjw@sisk.pl> <878xb35sje.fsf@goat.bogus.local> <20070612153102.GD5986@ucw.cz> <20070614181329.GA31277@gamma.logic.tuwien.ac.at> <20070722091010.GH3701@elf.ucw.cz> <20070812165202.GI5363@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070812165202.GI5363@gamma.logic.tuwien.ac.at>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.11+cvs20060126
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2007-08-12 18:52:02, Norbert Preining wrote:
> Hi Pavel, hi all,
> 
> On Son, 22 Jul 2007, Pavel Machek wrote:
> > > Ok, no beeping at all. Nothing after resume, only fan. And I did not
> > > forget to activate the BEEP line.
> > > 
> > > So where can I go from here? DSDT hacking? Anything else?
> > 
> > Hmm, it was 'hardware debugger' time when I hit similar problem few
> > years ago :-(.
> 
> Something else helped, don't ask me what, but with
> 
> 	2.6.32-rc2
> 
> and
> 
> 	s2ram -f -p
> 
> it does work. Even with X and 3D running. Nice.
> 
> Anything I should do now?

Submit whitelist entry to seife@suse.de?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

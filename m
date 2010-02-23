Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754147Ab0BWUcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 15:32:11 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:48080 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752649Ab0BWUcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 15:32:09 -0500
Date: Tue, 23 Feb 2010 21:32:02 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jean Delvare <khali@linux-fr.org>, lasse.collin@tukaani.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: ketchup was Re: [kernel.org users] XZ Migration discussion
Message-ID: <20100223203202.GA10467@elf.ucw.cz>
References: <4B744E13.8040004@kernel.org>
 <20100212150137.648dca7c@hyperion.delvare>
 <1265988318.24271.30.camel@gandalf.stny.rr.com>
 <20100216153905.GA1541@ucw.cz>
 <1266337061.24271.138.camel@gandalf.stny.rr.com>
 <20100216162745.GA1660@ucw.cz>
 <20100221135341.GC1307@ucw.cz>
 <20100222185928.GA1572@ucw.cz>
 <1266930873.19540.2.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266930873.19540.2.camel@frodo>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > > > Add --only-dl option -- when you want to cache the needed patches but
> > > > not apply anything yet.
> > > 
> > > Actually, you'll probably get a better patch if you relace 'only-dl'
> > > with just 'dl'. Mistaking --only-dl and --dl-only is just too easy.
> > 
> > This should work; save time&bandwidth by using incremental patches
> > between -rcX.
> > 
> > Is there testsuite for ketchup? It would be useful at this point...
> 
> I don't have one, but that would be helpful.
> 
> Would you like to take over maintaining ketchup? I took it over because
> Matt did not want it anymore and I was the last to send him patches.
> 
> I've been quite busy working on Ftrace, trace-cmd and kconfig stuff,
> that I'm willing to hand this over to you, if you want it. My last
> release of ketchup is my git tree on kernel.org.

I'd really prefer not to maintain it -- I'm using it on my zaurus,
because git is just too slow there -- but I don't really have time
just now.

(Plus, I'm not good enough with git, I'm afraid).

But, if you think the patches are good enough, I can just prepare
nice, easy to apply series? (But I'd really like someone to check that
the basic idea is right...)

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S1161373AbXD2VFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161373AbXD2VFd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 17:05:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161361AbXD2VFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 17:05:33 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:32799 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161339AbXD2VEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 17:04:54 -0400
Date: Sun, 29 Apr 2007 23:05:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429210505.GS3468@stusta.de>
References: <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com> <20070429201729.GQ3468@stusta.de> <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704291330280.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 01:33:16PM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 29 Apr 2007, Adrian Bunk wrote:
> > 
> > The kernel Bugzilla currently contains 1600 open bugs.
> 
> Adrian, why do you keep harping on this, and ignoring reality?
> 
> Kernel bugzilla has 1600 open bugs BECAUSE IT SUCKS.

OK, how do you suggest to track bugs in a way that doesn't suck?

Bug reports to linux-kernel have the big problem that they are lost if 
no developer immediately picks them up.

> How many of those are interesting and valid? How many of them are 
> relevant? How many of them are duplicates?
> 
> You don't know. Nobody does. So why do you bother reporting that number?

What I do know is that the majority of them has never been proper 
debugged by a kernel developer knowing the subsystem in question.

> That number is exactly as relevant as the number of dog-hairs on our couch 
> ("in the millions"). An impressively large number, definitely uncountable, 
> and definitely also not relevant to anythign at all. Not at all unlike 
> that "1600 open bugs" number that you bring up.
> 
> Do you think the number of dog-hairs on our couch is an argument for or 
> against people trying to track regressions? If not, why do you keep 
> bringing up bugzilla?

I tracked 2.6.21-rc regressions, and I do not scale for higher numbers 
of bugs. When I had to track 36 known regressions it was a real 
nightmare.

Bugzilla tracks regressions and scales for higher numbers of bugs.

Let me ask you two questions:
- Do you think regression tracking makes any sense at all?
- If yes, which scalable way of regression tracking would in your
  opinion not suck?

> 		Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


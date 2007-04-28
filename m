Return-Path: <linux-kernel-owner+w=401wt.eu-S1754358AbXD1XEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754358AbXD1XEI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXD1XEI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:04:08 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:37644 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754358AbXD1XEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:04:05 -0400
Date: Sun, 29 Apr 2007 01:04:16 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070428230416.GF3468@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 28, 2007 at 03:33:39PM -0700, Linus Torvalds wrote:
> 
> 
> On Sat, 28 Apr 2007, Adrian Bunk wrote:
> > 
> > We are already quite good at ignoring bug reports that come through 
> > linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> > than 1600 open bugs because this tells how bad we are at handling bugs.
> 
> No, it just shows that bugzilla doesn't matter for most of the kernel.
> 
> Don't say that "bugzilla tells how bad we are at handling bugs". It tells 
> how bad *bugzilla* is for handling bugs, nothing more.
> 
> Trying to play politics by pointing to bugzilla is pointless. Bugzilla is 
> used for a few subsystems (ACPI seems to use it actively, for example), 
> but I doubt most developers use it.
> 
> Would be be good to have a better bug-tracking setup? Yes. But I think it 
> takes man-power, and it would take something *fundamentally* better than 
> bugzilla.

Bugzilla has an email interface.
Andrew forwards bugs from Bugzilla to developers.

There might be small room for improvements, but I don't see how 
man-power or technology could make a big difference in this area.

> Maybe the new "http://kernelnewbies.org/known_regressions" thing will 
> evolve to something worth tracking. Right now, bugzilla isn't it (although 
> it can be a useful tracking place for individual bugs, *once* you've found 
> and gotten the right developer involved - but that's a huge step that 
> bugzilla generally does *not* do for us).

"*once* you've found and gotten the right developer involved" is the 
real problem, not how to track bugs.

And not only a developer active in this area, more important a 
developer who knows the subsystem/driver involved *and is willing
to work on bug reports*.

*This* is *the* problem.
And no change in bug tracking will help with this problem.

> 			Linus

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


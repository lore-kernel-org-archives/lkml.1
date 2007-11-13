Return-Path: <linux-kernel-owner+w=401wt.eu-S1762217AbXKMUEn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762217AbXKMUEn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 15:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759115AbXKMUEb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 15:04:31 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:49763 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759723AbXKMUEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 15:04:30 -0500
Date: Tue, 13 Nov 2007 21:04:07 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Mark Lord <liml@rtr.ca>, alsa-devel@alsa-project.org,
       netdev@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-kernel@vger.kernel.org, protasnb@gmail.com,
       David Miller <davem@davemloft.net>, linux-ide@vger.kernel.org,
       bugme-daemon@bugzilla.kernel.org, linux-input@atrey.karlin.mff.cuni.cz,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] New Kernel Bugs
Message-ID: <20071113200407.GK4250@stusta.de>
References: <20071113164650.GA28493@elte.hu> <4739E3D0.10201@rtr.ca> <20071113181228.GF4250@stusta.de> <4739EA83.5040006@rtr.ca> <20071113183605.GG4250@stusta.de> <4739F12E.5020807@rtr.ca> <20071113190428.GH4250@stusta.de> <4739F739.5040708@rtr.ca> <20071113193035.GI4250@stusta.de> <20071113194649.GE1356@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071113194649.GE1356@flint.arm.linux.org.uk>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 07:46:49PM +0000, Russell King wrote:
> On Tue, Nov 13, 2007 at 08:30:35PM +0100, Adrian Bunk wrote:
> > There is this silly limit that noone can work more than 168 hours per 
> > week on the Linux kernel, and some kernel developers seem to take the 
> > liberty of spending even less time on kernel development...
> 
> That limit of 168 hours applies all around the world to everyone.
> Moreover, not all kernel developers are employed to hack on the
> kernel for 168 hours a week.
> 
> For me, personally, that figure is in reality about 24 hours a
> week.  Yes, just 24.  The rest of the time (like *now*) is time I'm
> volunteering because I happen to be reading my email...
> 
> ... and happen to be wasting replying to discussions like this rather
> than reading that message which has just arrived on the ARM kernel
> mailing list from someone having problems using copy_from_user()
> with a kernel pointer.
> 
> So, please, stop this idea that somehow kernel developers can
> somehow spend infinite amounts of time solving lots and lots of
> bugs.

Sorry, that happens when using irony in a non-native language...

What I wanted to express:
Noone has unlimited time for kernel development.

> Russell King

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


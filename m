Return-Path: <linux-kernel-owner+w=401wt.eu-S1031357AbXD2URU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031357AbXD2URU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 16:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031359AbXD2URU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 16:17:20 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:32774 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1031357AbXD2URT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 16:17:19 -0400
Date: Sun, 29 Apr 2007 22:17:29 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Diego Calleja <diegocg@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429201729.GQ3468@stusta.de>
References: <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org> <20070429214007.9ea12e96.diegocg@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070429214007.9ea12e96.diegocg@gmail.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 09:40:07PM +0200, Diego Calleja wrote:
>...
> So unless someone is willing to write such tool (which I doubt, since it
> doesn't looks easy), all this discussion seems pointless, and we should
> stick with this http://kernelnewbies.org/known_regressions page
> which is showing to be quite useful :)

This list currently contains 29 known regressions.
Someone has to manually add them.
Someone has to manually track the status of all of them.
Someone has to manually group related regressions (e.g. in the same 
subsystem) together.

The kernel Bugzilla currently contains 1600 open bugs.

Maintaining a regression list by hand was really a pain when during 
2.6.21-rc we had 36 known regressions.

Any approach that does not involve some kind of tracker with some kind 
of database simply doesn't scale.

Bugzilla might not be perfect, but it works and it's better than doing 
it by hand.

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


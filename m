Return-Path: <linux-kernel-owner+w=401wt.eu-S1161309AbXD1WdG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161309AbXD1WdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:33:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161366AbXD1WdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:33:06 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37624 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161309AbXD1WdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:33:04 -0400
Date: Sun, 29 Apr 2007 00:33:14 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Neil Brown <neilb@suse.de>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070428223314.GD3468@stusta.de>
References: <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <46339BC7.6050802@mbligh.org> <17971.50834.907414.761549@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <17971.50834.907414.761549@notabene.brown>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:11:30AM +1000, Neil Brown wrote:
> On Saturday April 28, mbligh@mbligh.org wrote:
>...
> > As Andrew has pointed out before though - even though he forwards
> > the bugs, nobody does anything with it. The sad truth seems to be
> > that people have very little interest in fixing bugs when they are
> > reported - it's not sexy, I guess.
> 
> Not sexy, and also not at all easy.   A lot of the interesting bugs
> seem to be subtle interactions between separate parts of the kernel -
> one part making an assumption or exhibiting a behaviour that the other
> part didn't expect.  And we all know that writing bug^Wcode is easier
> than removing bugs.  I can spend hour and hours reading through code
> trying to get the big picture, and end up finding a one-line change
> that then needs documenting, testing and external review.  It's not
> easy.
> 
> > I'm still unconvinced the users or the tool are the problem, but if it
> > makes you happier, we can do that.
> 
> No, they aren't the problem.  Bugs are the problem.  But they might be
> a more effective part of the solution.
> 
> My perception of the kernel bugzilla is that visibility is very low.
> 
> I think there is value in weekly reminders, and I wouldn't mind seeing
> a weekly Email on linux-kernel with something like a list of open bugs
> that have not seen any activity in between 1 and 2 weeks.  It might
> get someone out-of-area interested, and might be noticed by someone
> who thinks they are in-area and get them wondering why they didn't
> find out when the bug was first reported.

The 100 kB email limit has to be lifted for this... 

More seriously, there are > 1000 open bugs in the kernel Bugzilla 
without any activity during the last 2 weeks.

The problem is usually either "Not sexy, and also not at all easy." or
"no maintainer".

Technology can assist, but there are non-technical problems you can't 
solve through technology.

> NeilBrown

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


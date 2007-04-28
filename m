Return-Path: <linux-kernel-owner+w=401wt.eu-S1754333AbXD1XKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333AbXD1XKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 19:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754384AbXD1XKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 19:10:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754281AbXD1XKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 19:10:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Adrian Bunk <bunk@stusta.de>
Subject: Re: Linux 2.6.21
Date: Sun, 29 Apr 2007 01:14:36 +0200
User-Agent: KMail/1.9.5
Cc: Neil Brown <neilb@suse.de>, "Martin J. Bligh" <mbligh@mbligh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
References: <20070426040806.GJ3468@stusta.de> <17971.50834.907414.761549@notabene.brown> <20070428223314.GD3468@stusta.de>
In-Reply-To: <20070428223314.GD3468@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704290114.38094.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 29 April 2007 00:33, Adrian Bunk wrote:
> On Sun, Apr 29, 2007 at 08:11:30AM +1000, Neil Brown wrote:
> > On Saturday April 28, mbligh@mbligh.org wrote:
> >...
> > > As Andrew has pointed out before though - even though he forwards
> > > the bugs, nobody does anything with it. The sad truth seems to be
> > > that people have very little interest in fixing bugs when they are
> > > reported - it's not sexy, I guess.
> > 
> > Not sexy, and also not at all easy.   A lot of the interesting bugs
> > seem to be subtle interactions between separate parts of the kernel -
> > one part making an assumption or exhibiting a behaviour that the other
> > part didn't expect.  And we all know that writing bug^Wcode is easier
> > than removing bugs.  I can spend hour and hours reading through code
> > trying to get the big picture, and end up finding a one-line change
> > that then needs documenting, testing and external review.  It's not
> > easy.
> > 
> > > I'm still unconvinced the users or the tool are the problem, but if it
> > > makes you happier, we can do that.
> > 
> > No, they aren't the problem.  Bugs are the problem.  But they might be
> > a more effective part of the solution.
> > 
> > My perception of the kernel bugzilla is that visibility is very low.
> > 
> > I think there is value in weekly reminders, and I wouldn't mind seeing
> > a weekly Email on linux-kernel with something like a list of open bugs
> > that have not seen any activity in between 1 and 2 weeks.  It might
> > get someone out-of-area interested, and might be noticed by someone
> > who thinks they are in-area and get them wondering why they didn't
> > find out when the bug was first reported.
> 
> The 100 kB email limit has to be lifted for this... 
> 
> More seriously, there are > 1000 open bugs in the kernel Bugzilla 
> without any activity during the last 2 weeks.
> 
> The problem is usually either "Not sexy, and also not at all easy." or
> "no maintainer".

Please add "limited human resources" to this list.

Greetings,
Rafael

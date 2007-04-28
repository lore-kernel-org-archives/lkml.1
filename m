Return-Path: <linux-kernel-owner+w=401wt.eu-S1031292AbXD1Wmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031292AbXD1Wmu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXD1Wmu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:42:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031292AbXD1Wmt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:42:49 -0400
From: Neil Brown <neilb@suse.de>
To: Adrian Bunk <bunk@stusta.de>
Date: Sun, 29 Apr 2007 08:42:25 +1000
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17971.52689.266239.2474@notabene.brown>
Cc: "Martin J. Bligh" <mbligh@mbligh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>
Subject: Re: Linux 2.6.21
In-Reply-To: message from Adrian Bunk on Sunday April 29
References: <20070426040806.GJ3468@stusta.de>
	<20070426125802.GL3468@stusta.de>
	<alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
	<4630DB24.4030005@redhat.com>
	<20070426201325.8a1ebda3.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
	<20070426224148.69b91b2e.diegocg@gmail.com>
	<alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
	<46339BC7.6050802@mbligh.org>
	<17971.50834.907414.761549@notabene.brown>
	<20070428223314.GD3468@stusta.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday April 29, bunk@stusta.de wrote:
> On Sun, Apr 29, 2007 at 08:11:30AM +1000, Neil Brown wrote:
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

I meant "between 1 and 2 weeks"  - so each bug hits linux-kernel once,
any only if no-one seem to care.
If I ask for bugs changed in the last 7 days I get 80
If I ask for bugs changed in the last 14 days I get 114.
So today, that list would have (114-80) = 34 bug, which I think it is
manageable to glance through and think "Would I like to care".

NeilBrown

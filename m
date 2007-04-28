Return-Path: <linux-kernel-owner+w=401wt.eu-S1161276AbXD1Web@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276AbXD1Web (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 18:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161333AbXD1Web
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 18:34:31 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:35992 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161276AbXD1Wea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 18:34:30 -0400
Date: Sat, 28 Apr 2007 15:33:39 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
cc: Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
In-Reply-To: <20070428195320.GZ3468@stusta.de>
Message-ID: <alpine.LFD.0.98.0704281529080.9964@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0704252014050.9964@woody.linux-foundation.org>
 <20070426040806.GJ3468@stusta.de> <20070426125802.GL3468@stusta.de>
 <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org>
 <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org>
 <20070426224148.69b91b2e.diegocg@gmail.com>
 <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org>
 <20070428195320.GZ3468@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 28 Apr 2007, Adrian Bunk wrote:
> 
> We are already quite good at ignoring bug reports that come through 
> linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> than 1600 open bugs because this tells how bad we are at handling bugs.

No, it just shows that bugzilla doesn't matter for most of the kernel.

Don't say that "bugzilla tells how bad we are at handling bugs". It tells 
how bad *bugzilla* is for handling bugs, nothing more.

Trying to play politics by pointing to bugzilla is pointless. Bugzilla is 
used for a few subsystems (ACPI seems to use it actively, for example), 
but I doubt most developers use it.

Would be be good to have a better bug-tracking setup? Yes. But I think it 
takes man-power, and it would take something *fundamentally* better than 
bugzilla.

Maybe the new "http://kernelnewbies.org/known_regressions" thing will 
evolve to something worth tracking. Right now, bugzilla isn't it (although 
it can be a useful tracking place for individual bugs, *once* you've found 
and gotten the right developer involved - but that's a huge step that 
bugzilla generally does *not* do for us).

			Linus

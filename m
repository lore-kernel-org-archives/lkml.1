Return-Path: <linux-kernel-owner+w=401wt.eu-S932396AbXD2HeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbXD2HeV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 03:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932382AbXD2HeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 03:34:21 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4646 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396AbXD2HeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 03:34:20 -0400
Date: Sun, 29 Apr 2007 08:34:07 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Diego Calleja <diegocg@gmail.com>, Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429073407.GB26094@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@stusta.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20070426125802.GL3468@stusta.de> <alpine.LFD.0.98.0704260828550.9964@woody.linux-foundation.org> <4630DB24.4030005@redhat.com> <20070426201325.8a1ebda3.diegocg@gmail.com> <alpine.LFD.0.98.0704261126010.9964@woody.linux-foundation.org> <20070426224148.69b91b2e.diegocg@gmail.com> <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428224904.GE3468@stusta.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 12:49:04AM +0200, Adrian Bunk wrote:
> On Sat, Apr 28, 2007 at 09:27:01PM +0100, Russell King wrote:
> > On Sat, Apr 28, 2007 at 09:53:20PM +0200, Adrian Bunk wrote:
> > > We are already quite good at ignoring bug reports that come through 
> > > linux-kernel, and it's an _advantage_ of the kernel Bugzilla to see more 
> > > than 1600 open bugs because this tells how bad we are at handling bugs.
> > > How many thousand bug reports have been ignored during the same time on 
> > > linux-kernel?
> > 
> > However, look at this bug:
> > 
> >   http://bugme.osdl.org/show_bug.cgi?id=7760
> > 
> > It's outside my knowledge to be able to fix for various reasons:
> >...
> > I'm personally very tempted to close it as "won't fix" (I wish there was
> > a "can't fix" category.)
> >...
> 
> So this is a completely debugged bug in a well-maintained subsystem
> (no matter what the status in Bugzilla is).

You're being very optimistic.

I'm not sure where you get the idea that it's "completely debugged".
It isn't - I've no real idea what the problem is, let alone what the
solution might be.  I've only one guess based upon what is sane in
the kernel, and that isn't even based on the data provided in the
bug report.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

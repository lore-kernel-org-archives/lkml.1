Return-Path: <linux-kernel-owner+w=401wt.eu-S1031080AbXD2TbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031080AbXD2TbY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:31:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXD2TbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:31:24 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3980 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031080AbXD2TbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:31:23 -0400
Date: Sun, 29 Apr 2007 20:31:10 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Andi Kleen <andi@firstfloor.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.21
Message-ID: <20070429193109.GA6533@flint.arm.linux.org.uk>
Mail-Followup-To: Andi Kleen <andi@firstfloor.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Adrian Bunk <bunk@stusta.de>, Diego Calleja <diegocg@gmail.com>,
	Chuck Ebbert <cebbert@redhat.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.0.98.0704261354560.9964@woody.linux-foundation.org> <20070428195320.GZ3468@stusta.de> <20070428202701.GA30343@flint.arm.linux.org.uk> <20070428224904.GE3468@stusta.de> <alpine.LFD.0.98.0704281601060.9964@woody.linux-foundation.org> <p73d51n1fup.fsf@bingen.suse.de> <alpine.LFD.0.98.0704290848360.9964@woody.linux-foundation.org> <20070429173500.GA30248@one.firstfloor.org> <alpine.LFD.0.98.0704291040580.9964@woody.linux-foundation.org> <20070429180909.GA30604@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070429180909.GA30604@one.firstfloor.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2007 at 08:09:09PM +0200, Andi Kleen wrote:
> >  - a lot of reporters will not use bugzilla, because it's damn 
> >    inconvenient even for reporting. If you propose something that uses 
> 
> Don't think that's true. There are plenty of projects who only
> accept bugs through bugzilla (mozilla, various distributions, etc.) 
> and I don't see any evidence of your claim being true.

There's an ARM category in the kernel.org bugzilla.  Folk are completely
free to submit ARM bugs to either the (closed) mailing list or bugzilla.

99.99999999% of bug reports in the ARM community come via the mailing
list.  I think to date there's been about 10 bugzilla entries since
Feb 2004.

This is inspite of me linking to the kernel.org bugzilla from my
website.

So it seems that virtually all the folk involved with the ARM kernel,
given a completely free choice, _prefer_ to send email-based bug
reports over touching bugzilla.

That's quite a different metric to projects forcing bugzilla on people,
and I'd say is a more valid metric to gauge whether bugzilla is really
suitable.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

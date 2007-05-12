Return-Path: <linux-kernel-owner+w=401wt.eu-S1758028AbXELQXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028AbXELQXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 12:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754382AbXELQW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 12:22:59 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2632 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754352AbXELQW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 12:22:58 -0400
Date: Sat, 12 May 2007 17:22:49 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates
Message-ID: <20070512162248.GB21729@flint.arm.linux.org.uk>
Mail-Followup-To: Pierre Ossman <drzeus-list@drzeus.cx>,
	Nicolas Pitre <nico@cam.org>, LKML <linux-kernel@vger.kernel.org>
References: <46375B18.4080802@drzeus.cx> <20070509185636.GB26981@flint.arm.linux.org.uk> <46421BB5.7040504@drzeus.cx> <20070509221253.GC26981@flint.arm.linux.org.uk> <4642B122.5070609@drzeus.cx> <46432502.4050901@drzeus.cx> <alpine.LFD.0.99.0705101037220.24220@xanadu.home> <alpine.LFD.0.99.0705121122440.24220@xanadu.home> <4645E76B.2060704@drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4645E76B.2060704@drzeus.cx>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2007 at 06:12:27PM +0200, Pierre Ossman wrote:
> Nicolas Pitre wrote:
> > Actually, I'm not the author of this workaround.  And looking at it 
> > closer, the current workaround is utterly buggy as it completely inhibit 
> > CRC error reporting for everything but the listed commands when the MSB 
> > of the response is a zero.
> >
> >   
> 
> Your name popped up on the commit for this, but as that was during the
> bk days the information was severely lacking.

That's not correct.  Just as today, it's entirely trackable.  We've had
the sign-off thing for quite a long time, and we've also had the ARM
patch system for ages.  That's what the "2271/3" number means.

http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=2271%2F1
http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=2271%2F3

First submitted on 22 November 2004 by Nicolas.  Went through a couple
of revisions until 2271/3 which was committed on 27 November 2004.  No
indication that the code was done by anyone other than Nicolas, though
maybe Nico didn't add appropriate creditation to the real authors.
Slap Wrist if we're missing the proper creditation!

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

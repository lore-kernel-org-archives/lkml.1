Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbYBMMZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbYBMMZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 07:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbYBMMZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 07:25:48 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42723 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbYBMMZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 07:25:47 -0500
Date: Wed, 13 Feb 2008 12:19:41 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       David Miller <davem@davemloft.net>, arjan@infradead.org,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: Announce: Linux-next (Or Andrew's dream :-))
Message-ID: <20080213121941.GC21694@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>, Greg KH <greg@kroah.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	David Miller <davem@davemloft.net>, arjan@infradead.org,
	sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	linux-next@vger.kernel.org, linux-arch@vger.kernel.org,
	akpm@linux-foundation.org
References: <47B1CB08.4020101@garzik.org> <alpine.LFD.1.00.0802120847500.2920@woody.linux-foundation.org> <1202838082.3137.54.camel@localhost.localdomain> <alpine.LFD.1.00.0802120945290.2920@woody.linux-foundation.org> <1202840682.3137.83.camel@localhost.localdomain> <alpine.LFD.1.00.0802121037340.2920@woody.linux-foundation.org> <alpine.LFD.1.00.0802121051341.2920@woody.linux-foundation.org> <20080212191914.GB20883@kroah.com> <20080213100503.GA21694@flint.arm.linux.org.uk> <47B2DD40.70106@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47B2DD40.70106@garzik.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2008 at 07:06:24AM -0500, Jeff Garzik wrote:
> Russell King wrote:
> >We know that the -mm tree is pretty much useless in terms of code
> >coverage for ARM, and it's getting increasingly unlikely that anything
> >short of a build of all ARM defconfigs will pick up on merge issues -
> >which is a lot of CPU cycles, and I'm not going to insist its something
> >that should be done.
> 
> 
> If you need help in that area (build-testing ARM), surely we can find 
> some fast machines that can do builds for you.  Any interest?

It would probably make some sense - it would help to get hold of the
infrastructure that armlinux.simtec.co.uk uses to run their test builds
of Linus' tree and apply it (on a separate machine) to -mm (or
indeed whatever other) kernels.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758650AbYB1JUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650AbYB1JUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 04:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754783AbYB1JTv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 04:19:51 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48733 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723AbYB1JTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 04:19:49 -0500
Date: Thu, 28 Feb 2008 09:15:36 +0000
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
       Dominik Brodowski <linux@brodo.de>
Subject: Re: [2.6 patch] the long overdue pcmcia_ioctl.c removal
Message-ID: <20080228091536.GA23304@flint.arm.linux.org.uk>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-pcmcia@lists.infradead.org, linux-kernel@vger.kernel.org,
	Dominik Brodowski <linux@brodo.de>
References: <20080213213115.GW3383@cs181133002.pp.htv.fi> <20080218050133.23454db1.akpm@linux-foundation.org> <20080227181303.GB29269@cs181133002.pp.htv.fi> <20080227204407.GA10455@flint.arm.linux.org.uk> <20080228002457.30489.qmail@cdy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228002457.30489.qmail@cdy.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 01:24:57AM +0100, Peter Stuge wrote:
> (Really cross-post like this?)
> 
> On Wed, Feb 27, 2008 at 08:44:07PM +0000, Russell King wrote:
> > TBH I've given up trying to fight this continue "lets remove these
> > IOCTLs which no one uses" crap.  Obviously, _I_ use them.
> 
> I suppose critical mass or other powers that be have decided they
> aren't good enough. If your userspace will never change, settling
> on a kernel as well shouldn't be too big a deal.
> 
> Closed source sure sucks.

It's not closed source, but a case of "the machine with the CVS on was
taken down a couple of months after the project ended".

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

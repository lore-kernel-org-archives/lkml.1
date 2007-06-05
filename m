Return-Path: <linux-kernel-owner+w=401wt.eu-S1765559AbXFEPp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765559AbXFEPp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762850AbXFEPpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:45:45 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:3214 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765499AbXFEPpl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:45:41 -0400
Date: Tue, 5 Jun 2007 16:45:31 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605154531.GA29508@flint.arm.linux.org.uk>
References: <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605143523.GE31565@havoc.gtf.org> <20070605145149.GB2572@flint.arm.linux.org.uk> <20070605145603.GF31565@havoc.gtf.org> <20070605145945.GC2572@flint.arm.linux.org.uk> <20070605151104.GG31565@havoc.gtf.org> <20070605151847.GD2572@flint.arm.linux.org.uk> <20070605154157.GH31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605154157.GH31565@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:41:57AM -0400, Jeff Garzik wrote:
> On Tue, Jun 05, 2007 at 04:18:47PM +0100, Russell King wrote:
> > Meanwhile you decide that you have a right over _MY_ personal preferences.
> > It's the same argument I'm afraid, just a different point of view.  If
> > _you_ do not wish to abide by the header then turn off that feature in
> > your mailer.  That's _your_ preference and one which _you_ can set.
> 
> That clearly doesn't fix the MUAs of everyone else, which has the
> stated behavior:  if Mail-Followup-To is present, stuff everyone into
> the To header.  And who originates this header?
> 
> It's a broken behavior overall, and in a sane world, it would excise you
> from the To: header, and leave everyone else on CC as per normal MUA
> standards.  But it's not a sane world :)
> 
> As such, it is -your- responsibility to make sure breakage does not
> occur, since the breakage is originated from -your- setup.

There's no point discussing this any further - I've unsubscribed from
linux-kernel.  Problem solved.

| From:   Majordomo@vger.kernel.org
| Subject: Majordomo results: unsubscribe
| Reply-To: Majordomo@vger.kernel.org
| Date:   Tue, 5 Jun 2007 11:22:06 -0400
| 
| --
| 
| >>>> unsubscribe linux-kernel
| Succeeded.
| >>>> end
| END OF COMMANDS

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

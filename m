Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbXFEWQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbXFEWQm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 18:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763433AbXFEWQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 18:16:31 -0400
Received: from havoc.gtf.org ([69.61.125.42]:45102 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762919AbXFEWQa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 18:16:30 -0400
Date: Tue, 5 Jun 2007 18:16:25 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: David Miller <davem@davemloft.net>, alan@lxorguk.ukuu.org.uk,
       hch@infradead.org, mroos@linux.ee, linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605221625.GU31565@havoc.gtf.org>
References: <20070605151104.GG31565@havoc.gtf.org> <20070605151847.GD2572@flint.arm.linux.org.uk> <20070605152133.GE2572@flint.arm.linux.org.uk> <20070605.122745.118950378.davem@davemloft.net> <20070605212523.GB18027@flint.arm.linux.org.uk> <20070605213815.GA19648@flint.arm.linux.org.uk> <20070605214830.GS31565@havoc.gtf.org> <20070605220345.GA22705@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605220345.GA22705@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:03:45PM +0100, Russell King wrote:
> On Tue, Jun 05, 2007 at 05:48:30PM -0400, Jeff Garzik wrote:
> > On Tue, Jun 05, 2007 at 10:38:15PM +0100, Russell King wrote:
> > > There is one final point on this which I wish to make, in case anyone
> > > has decided that this is caused by some recent change at my end.
> > > 
> > > I've been adding this header to all my messages for about the last seven
> > > years.  It's only *just* become a problem because someone here made a
> > > decision that it was a problem.
> > 
> > Search LKML for other mentions of Mail-Followup-To; this is far from the
> > first time it's been brought up.
> > 
> > I'm probably one of the few who actually investigated why their MUA was
> > suddenly doing weird, RFC-unfriendly things to the To/CC headers,
> > tracking it down the Mail-Followup-To header.
> 
> And rather than configuring your MUA to ignore the header...

> You're using mutt, mutt can be configured so.

So, you are seriously proposing that EVERYONE reconfigure their MUA,
because you are sending out bad headers?

Don't you think that is an unscalable solution, and an imposition?

	Jeff




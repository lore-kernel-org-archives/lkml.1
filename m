Return-Path: <linux-kernel-owner+w=401wt.eu-S1765356AbXFEPmP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765356AbXFEPmP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:42:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764582AbXFEPmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:42:00 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42953 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764882AbXFEPl7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:41:59 -0400
Date: Tue, 5 Jun 2007 11:41:57 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605154157.GH31565@havoc.gtf.org>
References: <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605143523.GE31565@havoc.gtf.org> <20070605145149.GB2572@flint.arm.linux.org.uk> <20070605145603.GF31565@havoc.gtf.org> <20070605145945.GC2572@flint.arm.linux.org.uk> <20070605151104.GG31565@havoc.gtf.org> <20070605151847.GD2572@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605151847.GD2572@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 04:18:47PM +0100, Russell King wrote:
> Meanwhile you decide that you have a right over _MY_ personal preferences.
> It's the same argument I'm afraid, just a different point of view.  If
> _you_ do not wish to abide by the header then turn off that feature in
> your mailer.  That's _your_ preference and one which _you_ can set.

That clearly doesn't fix the MUAs of everyone else, which has the
stated behavior:  if Mail-Followup-To is present, stuff everyone into
the To header.  And who originates this header?

It's a broken behavior overall, and in a sane world, it would excise you
from the To: header, and leave everyone else on CC as per normal MUA
standards.  But it's not a sane world :)

As such, it is -your- responsibility to make sure breakage does not
occur, since the breakage is originated from -your- setup.

	Jeff




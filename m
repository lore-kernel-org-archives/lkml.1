Return-Path: <linux-kernel-owner+w=401wt.eu-S1765453AbXFEPTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765453AbXFEPTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764791AbXFEPTE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:19:04 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:2311 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764760AbXFEPTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:19:01 -0400
Date: Tue, 5 Jun 2007 16:18:47 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605151847.GD2572@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	David Miller <davem@davemloft.net>, mroos@linux.ee,
	linux-kernel@vger.kernel.org
References: <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605143523.GE31565@havoc.gtf.org> <20070605145149.GB2572@flint.arm.linux.org.uk> <20070605145603.GF31565@havoc.gtf.org> <20070605145945.GC2572@flint.arm.linux.org.uk> <20070605151104.GG31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605151104.GG31565@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 11:11:04AM -0400, Jeff Garzik wrote:
> On Tue, Jun 05, 2007 at 03:59:46PM +0100, Russell King wrote:
> > It's the fact that I _am_ CC'd on replies, so I get one message from LKML
> > one from the original poster, maybe one via another mailing list if it's
> > also copied there.  Add that in to the mix of all the other mail hitting
> > my MTA and the probability for the machine to exhaust it's limited VM is
> > very high.
> 
> This is an utterly ridiculous argument.  You are subscribed to LKML,
> with a message size limit of 400K.  "replies to rmk" are clearly lost
> in the noise compared to the rest of the list traffic.

Shrug, that's your opinion.  My real life experience is some what
different - I'm the one admin'ing these machines so I can see what's
going on.

> > Give me a way to stop people CC'ing me on replies and I'll happily remove
> > the header.  Unfortunately there isn't, so I can't.
> 
> So by fiat, you decide that gives you the right to override OTHER
> PEOPLE'S personal preferences?  Why are you so much more important
> to a thread than everyone else?

Meanwhile you decide that you have a right over _MY_ personal preferences.
It's the same argument I'm afraid, just a different point of view.  If
_you_ do not wish to abide by the header then turn off that feature in
your mailer.  That's _your_ preference and one which _you_ can set.

> If you are unwilling to fix the problem and work within existing
> community email standards, I think it would be fair to ask vger
> postmaster to start excising Mail-Followup-To headers.

Well, that will leave me with _no_ _choice_ but to arrange for the
SMTP MAIL FROM from others to receive a 550 error code to remove
the problem.  Is that really what you'd like me to do?

> You are NOT more important that everyone else.

That's not the issue.

Since it's obvious that you don't accept my argument, it's pointless
discussing it further; there's nothing I can realistically do at this
end to resolve the issue and still remain part of this community.

I see no point in further discussion of this issue if such bigotry is
going to continue; any further responses on this topic will not receive
any replies from me.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

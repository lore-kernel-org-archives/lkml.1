Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbXFEO4m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbXFEO4m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:56:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932679AbXFEO4H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:56:07 -0400
Received: from havoc.gtf.org ([69.61.125.42]:42625 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643AbXFEO4F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:56:05 -0400
Date: Tue, 5 Jun 2007 10:56:03 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605145603.GF31565@havoc.gtf.org>
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605143523.GE31565@havoc.gtf.org> <20070605145149.GB2572@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605145149.GB2572@flint.arm.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 03:51:49PM +0100, Russell King wrote:
> On Tue, Jun 05, 2007 at 10:35:23AM -0400, Jeff Garzik wrote:
> > 
> > BTW, please fix your mailer.  It emits Mail-Followup-To headers that
> > hijack everyone on the thread into the To field, breaking the normal
> > LKML To/CC standard replying mechanism that has been working for a
> > decade.
> 
> Sorry, I will not.  My local policy (which I have the utmost right to
> have) is that I do not wish to be CC'd on responses to replies to my
> posts.  Additional useless CC's are a waste of my limited bandwidth
> and resources.
> 
> It's a question of local policy required by local resource limitations.
> 
> So I give you a choice: you can either have the benefit of me reply and
> put up with the follow up header, or I will arrange to never reply to
> your messages ever again (which may involve me never reading one again).
> Which would you prefer?

Your personal preference is fine with me.

Just stop hijacking -everyone else's- preferences along with it.

A far more community-friendly method that operates within existing email
standards is to filter out duplicate message ids on your side.

	Jeff




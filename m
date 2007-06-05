Return-Path: <linux-kernel-owner+w=401wt.eu-S932680AbXFEOwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932680AbXFEOwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 10:52:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbXFEOwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 10:52:01 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4087 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295AbXFEOv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 10:51:59 -0400
Date: Tue, 5 Jun 2007 15:51:49 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, mroos@linux.ee,
       linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
Message-ID: <20070605145149.GB2572@flint.arm.linux.org.uk>
Mail-Followup-To: Jeff Garzik <jeff@garzik.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Christoph Hellwig <hch@infradead.org>,
	David Miller <davem@davemloft.net>, mroos@linux.ee,
	linux-kernel@vger.kernel.org
References: <Pine.SOC.4.64.0706032314590.20033@math> <20070603.174010.41894721.davem@davemloft.net> <20070604074719.GB15390@infradead.org> <20070604171952.GA3437@dhcp83-182.boston.redhat.com> <20070605122218.410d611b@the-village.bc.nu> <20070605135608.GA31565@havoc.gtf.org> <20070605141714.GA2572@flint.arm.linux.org.uk> <20070605143523.GE31565@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070605143523.GE31565@havoc.gtf.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2007 at 10:35:23AM -0400, Jeff Garzik wrote:
> 
> BTW, please fix your mailer.  It emits Mail-Followup-To headers that
> hijack everyone on the thread into the To field, breaking the normal
> LKML To/CC standard replying mechanism that has been working for a
> decade.

Sorry, I will not.  My local policy (which I have the utmost right to
have) is that I do not wish to be CC'd on responses to replies to my
posts.  Additional useless CC's are a waste of my limited bandwidth
and resources.

It's a question of local policy required by local resource limitations.

So I give you a choice: you can either have the benefit of me reply and
put up with the follow up header, or I will arrange to never reply to
your messages ever again (which may involve me never reading one again).
Which would you prefer?


rmk - who has regular fights with the OOM killer taking out name and
mail servers.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

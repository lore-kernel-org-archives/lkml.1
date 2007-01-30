Return-Path: <linux-kernel-owner+w=401wt.eu-S1751737AbXA3TgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737AbXA3TgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751759AbXA3TgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:36:21 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49709 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751737AbXA3TgV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:36:21 -0500
Message-ID: <45BF9E32.60309@garzik.org>
Date: Tue, 30 Jan 2007 14:36:18 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<45BF8C57.1020500@garzik.org> <adasldsqqvz.fsf@cisco.com>
In-Reply-To: <adasldsqqvz.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> What are our standards for maintenance?  How can we tell in advance if
> something is going to be maintained (cf. drivers/net/chelsio)?
> 
> I don't think you can seriously argue that just posting documentation
> is going to guarantee that a device is going to get a high-quality
> driver that runs on all architectures and that enterprise distros will
> support.

Look up from infiniband once in and while, and... surprise... that's 
what is actually happening.  It sure seems to me like the drivers 
maintained by hardware vendors directly is in the distinct minority, 
illuminating irrefutable evidence that hardware vendors do in fact 
receive high quality drivers in exchange for documentation (and 
hardware) availability.  IMO the drivers of the highest quality are 
usually in the this category.


> And I don't think it's a good strategy to try convince
> vendors to open docs by using happy talk about an idealized fantasy world.

Agreed.  That's why Greg was describing the real world of Linux kernel 
development, rather than an idealized fantasy world.

How do you think you got all these highly portable ATA, USB, network, 
and sound drivers, hmmm?  The vast majority was just documentation and 
hardware access.  That's been the Linux way since 1993 (1991?).

	Jeff




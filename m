Return-Path: <linux-kernel-owner+w=401wt.eu-S1750906AbXA3TqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750906AbXA3TqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 14:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750959AbXA3TqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 14:46:18 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:49766 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbXA3TqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 14:46:18 -0500
Message-ID: <45BFA087.6020905@garzik.org>
Date: Tue, 30 Jan 2007 14:46:15 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>
In-Reply-To: <adaodogqpmx.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
> Well, we can disagree about the majority of drivers.  My feeling is
> that most of the drivers that are really used by lots of people get
> support beyond just a dump of docs -- in fact often vendors are
> maintaining them, eg e1000, tg3, cciss, etc., to pick some running on
> the boxes I have around here.

Check your history...  tg3 was written by me and DaveM, and only after 
years was it picked up by the vendor as their official Linux driver. 
You have picked an excellent counter-example to your own argument.


>  > > Just look at the in-tree drivers: there are tons of them that don't
>  > > work on big-endian platforms, or have 64-bit problems, or have no SMP
>  > > support.  And that doesn't even count drivers that are so bitrotted
>  > > they won't even build any more.
>  > 
>  > Like Jeff said, many of these are quite old.
> 
> OK, but why isn't your army of volunteers fixing them?

Because nobody has hardware for them?


> And I seem to recall there's more SATA chipset documentation than Jeff
> Garzik has time to implement support for.

I seriously doubt you can come up with even a single concrete example here.

Regardless, libata has 55+ drivers and counting, all for the price of 
documentation and hardware.  Another quite strong counter example.


> I'm disagreeing with a stronger assertion -- your original email said
> that if a vendor just dumps out hardware documentation and donates a
> few devices, then that vendor will definitely get a driver that will
> be picked up by enterprise distros and run on every Linux platform.
> And that just isn't true, or at least experience shows it hasn't been
> true until now.

What experience?  AFAICS, pretty much all modern hardware in use outside 
of ATI/NVIDIA graphics is supported by Linux.

All visible evidence points to support for Greg's assertion.

	Jeff



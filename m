Return-Path: <linux-kernel-owner+w=401wt.eu-S1752015AbXA3XJz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbXA3XJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 18:09:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018AbXA3XJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 18:09:54 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:51465 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbXA3XJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 18:09:53 -0500
Message-ID: <45BFD03F.4020003@garzik.org>
Date: Tue, 30 Jan 2007 18:09:51 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Roland Dreier <rdreier@cisco.com>
CC: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Free Linux Driver Development!
References: <20070130012904.GA9617@kroah.com> <ada8xfks90x.fsf@cisco.com>	<20070130191020.GF20642@kroah.com> <adaodogqpmx.fsf@cisco.com>	<20070130195445.GE22022@kroah.com> <adazm80p4qp.fsf@cisco.com>	<45BFC7F2.7090209@garzik.org> <adaac00p1rq.fsf@cisco.com>
In-Reply-To: <adaac00p1rq.fsf@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.7 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier wrote:
>  > Which of these actively maintained and supported drivers work on only
>  > one platform[1], and are excluded from enterprise distros?  Can we
>  > truly count them as "many", as you repeatedly claim?
> 
> Why do we restrict this to actively maintained and supported drivers
> (I think abandonware drivers are highly relevant here...)?  And why
> are you asking about drivers that work on only one platform?  Greg
> promised support for every platform that has the right bus to plug a
> device into.  So things like drivers that don't work on SMP or 64-bit
> or big-endian platforms also violate that pledge, even if there's more
> than one 32-bit little-endian uniprocessor platform where the driver
> does work.

You were complaining about drivers that work on only one platform. 
Thus, I asked for list of said drivers, drivers that break Greg's pledge.

I'm betting they are uniformly ancient ISA or m68k or whatnot drivers.


> Anyway, grepping for stuff like BROKEN or !64BIT or X86 in the Kconfig
> dependencies under drivers/ finds tons of hits.  I don't have time to
> scan through and figure out which meet your criteria, and I honestly

Translation:  you don't have a clue what you are talking about, because 
you haven't even bothered to do such a search yourself.

This is /your/ criteria we are discussing.  /You/ keep talking about 
"many" (your words) non-portable and broken drivers.  And now you 
actively avoid citing examples.  Oh, except for one:  aha154x, an 
ancient ISA driver.  So, yes, I concede that if a vendor appears and 
wants to push in a new driver for ancient ISA hardware that nobody in 
the planet uses... it might not find a volunteer.  Hooray for goofy 
examples.


> I don't really understand why it's so hard to accept that sometimes
> even open specs aren't enough to get great Linux support.

And hooray for shifting arguments.  If this is your summary of the 
thread, do you now concede that Greg was not being disingenuous?  Open 
specs was not the sum toto of Greg's piece.

	Jeff



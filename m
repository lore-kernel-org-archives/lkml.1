Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbZFLBwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbZFLBwU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 21:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755445AbZFLBwM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 21:52:12 -0400
Received: from relais.videotron.ca ([24.201.245.36]:60103 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZFLBwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 21:52:12 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 11 Jun 2009 21:51:53 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
X-X-Sender: nico@xanadu.home
To: Ryan Mallon <ryan@bluewatersys.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Miller <davem@davemloft.net>, swetland@google.com, pavel@ucw.cz,
       lkml <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.arm.linux.org.uk, san@android.com,
       rlove@google.com
Subject: Re: HTC Dream aka. t-mobile g1 support
In-reply-to: <4A31AECA.6070303@bluewatersys.com>
Message-id: <alpine.LFD.2.00.0906112138090.31536@xanadu.home>
References: <20090611111821.GK795@n2100.arm.linux.org.uk>
 <20090611.042226.28424489.davem@davemloft.net>
 <20090611114911.GL795@n2100.arm.linux.org.uk>
 <20090611.050030.169859977.davem@davemloft.net>
 <20090611123852.GM795@n2100.arm.linux.org.uk>
 <20090611135442.6b9ab315@lxorguk.ukuu.org.uk>
 <20090611132134.GA11199@atomide.com>
 <20090611133736.GP795@n2100.arm.linux.org.uk>
 <20090611140038.GB11199@atomide.com>
 <20090611140624.GS795@n2100.arm.linux.org.uk>
 <alpine.LFD.2.00.0906111314510.31536@xanadu.home>
 <4A3175AC.9070100@bluewatersys.com>
 <alpine.LFD.2.00.0906112105220.31536@xanadu.home>
 <4A31AECA.6070303@bluewatersys.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jun 2009, Ryan Mallon wrote:

> Nicolas Pitre wrote:
> > This is all fine.  If you prefer some external help to judge your 
> > patches that's OK.  In fact I'm not advocating for people to stop 
> > posting their patches to linux-arm-kernel at all.  It is a good thing 
> > for patches to be aired on the mailing list for everyone to see and 
> > comment.
> > 
> > However if you start gathering more developers around the ep93xx then 
> > someone should take charge and be responsible for it.  And this must not 
> > necessarily be Russell as his cycles are not infinite.
> 
> Thats my point though: In the meantime, it falls on Russell by default
> to be the one to verify all the patches going through. I think the same
> is true for new architectures, if nobody else has the interest/hardware
> besides those posting the patches, then who is meant to do the
> reviewing/acking?

I think that, at some point, if nobody else has the interest/hardware, 
then you are on your own.  Just make sure that your code respects the 
kernel coding style, has no obvious API misuses, and that it does not 
affect anyone else.  At that point if you can convince people that your 
code is actually useful and that you'll be around to quickly respond 
if/when issues are reported then it should just be merged.


Nicolas

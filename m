Return-Path: <linux-kernel-owner+w=401wt.eu-S1030834AbXCNJng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030834AbXCNJng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030832AbXCNJng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:43:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:32415 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030834AbXCNJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=HICT13Kh84f7APzOcGwzrlpxoEMdkOotjaTj2Gzy67MeypdWJfbRshZVIaGYCpBZaTYqDgL05AN+hTOPB4eqAYvo+mHglDcbmumOwH5UWpntO4KprmOWmZ01/oWdbsnOzk93RhHYR9WxOSzKg3PoHxn2lNMQdC3AXAClJUBRWBw=
Message-ID: <9debc4410703140243n476b4aeaw879b29f201d04c4c@mail.gmail.com>
Date: Wed, 14 Mar 2007 15:13:32 +0530
From: "Maxin John" <maxin.john@gmail.com>
To: "Ben Dooks" <ben@fluff.org.uk>
Subject: Re: Need help on mach-ep93xx
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20070313112411.GA24508@fluff.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9debc4410703122224n5def90e7g4767b95b176941c0@mail.gmail.com>
	 <20070313112411.GA24508@fluff.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Many thanks to Lennert Buytenhek.

Try applying:

         http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=4122/1


On 3/13/07, Ben Dooks <ben@fluff.org.uk> wrote:
> On Tue, Mar 13, 2007 at 10:54:08AM +0530, Maxin John wrote:
> > Hi,
> >
> > I have one question mach-ep93xx.
> >
> > In  EP93xx  IRQ handling part in core.c,  the 2.6.19.2 kernel and
> > newer  kernels are configuring the 16 interrupts of the ports A & B
> > together. The code is not using the  interrupt capability  of the port
> > F which can provide 3 interrupts.
> >
> > Why the port F is not configured for interrupts ?
> >
> > Thanks in advance,
>
> subscribe to the linux-arm-kernel list and ask
> the question there, you'll find more ARM people there.
>
> --
> Ben (ben@fluff.org, http://www.fluff.org/)
>
>   'a smiley only costs 4 bytes'
>

Sincerely,

Maxin B. john
India

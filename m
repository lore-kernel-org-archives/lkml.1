Return-Path: <linux-kernel-owner+w=401wt.eu-S935968AbXHMQnV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935968AbXHMQnV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:43:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S970039AbXHMPwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:52:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:34452 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969955AbXHMPwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:52:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qpyLk3nFHntdcv0p7fTkawO5oskDTiMpocz3Mq7HrRDawABfRzc5DYY4KBR116ZT/f0Qzp0KndZRPhr49OaB4y+PCSpWSVfO47E7aPn4vkLVvRzxYOYhmHGu42e0t0fg6W9vaPMYJ/YUnPKEDK3YlbOHT4/v1yP1NuRsQP8RaFk=
Message-ID: <a781481a0708130851v4499dddfp2b62ba206856a5b3@mail.gmail.com>
Date: Mon, 13 Aug 2007 21:21:58 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [472/2many] MAINTAINERS - TI OMAP MMC INTERFACE DRIVER
Cc: joe@perches.com, torvalds@linux-foundation.org,
       linux-omap-open-source@linux.omap.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <a781481a0708130840w688e7a2eua7d7b5ec89bc5ad4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffc14.hGERPpPFcYe9DKoT%joe@perches.com>
	 <20070813121807.26014455@the-village.bc.nu>
	 <a781481a0708130840w688e7a2eua7d7b5ec89bc5ad4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 8/13/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> > On Sun, 12 Aug 2007 23:37:08 -0700
> > joe@perches.com wrote:
> >
> > > Add file pattern to MAINTAINER entry
> > >
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index af16a17..7a7f837 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -4478,7 +4478,7 @@ F:      drivers/misc/tifm*
> > >  F:   drivers/mmc/host/tifm_sd.c
> > >
> > >  TI OMAP MMC INTERFACE DRIVER
> > > -P:   Carlos Aguiar, Anderson Briglia and Syed Khasim
> > > +P:   Carlos Aguiar - Anderson Briglia - Syed Khasim
> >
> > NAK, Please stop sneaking other irrelevant changes into the patchset
>
> Joe, it's okay to have multiple "P:" entries for the same driver/subsystem
> in MAINTAINERS (grep BLACKFIN ARCHITECTURE for an extreme example :-)
> So you could probably do something like that here as well (but continue
> to have a single "M:" entry),

Well, three maintainers listed for this driver, but the only email address
they want to give out there is:

linux-omap-open-source@linux.omap.com

which leads to:

"You are not allowed to post to this mailing list, and your message has
been automatically rejected.  If you think that your messages are
being rejected in error, contact the mailing list owner at
linux-omap-open-source-owner@linux.omap.com."

I think the real "bad patch" that should've been "NAK"ed here was the
original patch to MAINTAINERS itself that introduced this entry.


> though as Alan mentions it isn't really good
> to make different kind of changes in the same patch.
>
> BTW bad, sad, things happened to my mailbox while I was away :-(
>
> Satyam
>

Return-Path: <linux-kernel-owner+w=401wt.eu-S1030964AbXHMQgQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030964AbXHMQgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:36:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933931AbXHMPlD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 11:41:03 -0400
Received: from nz-out-0506.google.com ([64.233.162.234]:33684 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967201AbXHMPk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 11:40:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=MHREsyj2Aw9+50Rcxpcxt5mjgVsTpp6TvAd+i1xxbQild5/7Ob5j0yhJtrnOX+OD9X/gKexRvf2OzUzjFmejq8Sqr9m5CYOQQ/0TH0cvTi3qM37xEDRZyuYb3lR4uubQn6+DOLHP0krW+NEUExzNd0cwIAJuCQm4cl18BpPIV4k=
Message-ID: <a781481a0708130840w688e7a2eua7d7b5ec89bc5ad4@mail.gmail.com>
Date: Mon, 13 Aug 2007 21:10:56 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] [472/2many] MAINTAINERS - TI OMAP MMC INTERFACE DRIVER
Cc: joe@perches.com, torvalds@linux-foundation.org,
       linux-omap-open-source@linux.omap.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
In-Reply-To: <20070813121807.26014455@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46bffc14.hGERPpPFcYe9DKoT%joe@perches.com>
	 <20070813121807.26014455@the-village.bc.nu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/07, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Sun, 12 Aug 2007 23:37:08 -0700
> joe@perches.com wrote:
>
> > Add file pattern to MAINTAINER entry
> >
> > Signed-off-by: Joe Perches <joe@perches.com>
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index af16a17..7a7f837 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -4478,7 +4478,7 @@ F:      drivers/misc/tifm*
> >  F:   drivers/mmc/host/tifm_sd.c
> >
> >  TI OMAP MMC INTERFACE DRIVER
> > -P:   Carlos Aguiar, Anderson Briglia and Syed Khasim
> > +P:   Carlos Aguiar - Anderson Briglia - Syed Khasim
>
> NAK, Please stop sneaking other irrelevant changes into the patchset

Joe, it's okay to have multiple "P:" entries for the same driver/subsystem
in MAINTAINERS (grep BLACKFIN ARCHITECTURE for an extreme example :-)
So you could probably do something like that here as well (but continue
to have a single "M:" entry), though as Alan mentions it isn't really good
to make different kind of changes in the same patch.

BTW bad, sad, things happened to my mailbox while I was away :-(

Satyam

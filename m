Return-Path: <linux-kernel-owner+w=401wt.eu-S1031961AbXHMQr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031961AbXHMQr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 12:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S972050AbXHMQA5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 12:00:57 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3087 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030857AbXHMQAz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 12:00:55 -0400
Subject: Re: [PATCH] [394/2many] MAINTAINERS - PXA2xx SUPPORT
From: Joe Perches <joe@perches.com>
To: Nicolas Pitre <nico@cam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
In-Reply-To: <alpine.LFD.0.999.0708131009480.5415@xanadu.home>
References: <46bffb75.pNKePQf1hTn1GZ01%joe@perches.com>
	 <alpine.LFD.0.999.0708131009480.5415@xanadu.home>
Content-Type: text/plain
Date: Mon, 13 Aug 2007 08:59:35 -0700
Message-Id: <1187020775.10249.86.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-08-13 at 10:14 -0400, Nicolas Pitre wrote:
> On Sun, 12 Aug 2007, joe@perches.com wrote:
> 
> > Add file pattern to MAINTAINER entry
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3889034..6e99107 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3768,6 +3768,11 @@ P:	Nicolas Pitre
> >  M:	nico@cam.org
> >  L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
> >  S:	Maintained
> > +F:	Documentation/spi/pxa2xx
> > +F:	drivers/pcmcia/pxa2xx*
> > +F:	drivers/spi/pxa2xx*
> > +F:	drivers/usb/gadget/pxa2xx*
> > +F:	sound/soc/pxa/pxa2xx*
> 
> Please don't apply this one as is.  The spi and usb bits weren't written 
> by me, and given that I don't have access to the corresponding hardware 
> at the moment, I'd have a really hard time maintaining those bits.

What's your pleasure?  Prefer this?

+F:	Documentation/spi/pxa2xx
+F:	drivers/pcmcia/pxa2xx*
+F:	sound/soc/pxa/pxa2xx*



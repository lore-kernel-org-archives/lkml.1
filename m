Return-Path: <linux-kernel-owner+w=401wt.eu-S1762303AbXGFPzt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762303AbXGFPzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 11:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762863AbXGFPzc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 11:55:32 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:49279 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762357AbXGFPzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 11:55:31 -0400
X-Originating-Ip: 72.143.66.27
Date: Fri, 6 Jul 2007 11:53:11 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, gregkh@suse.de
Subject: Re: [PATCH] USB:  Remove Makefile reference to obsolete OHCI_AT91.
In-Reply-To: <20070706084910.4e5fc20f.randy.dunlap@oracle.com>
Message-ID: <Pine.LNX.4.64.0707061152090.32394@localhost.localdomain>
References: <Pine.LNX.4.64.0707060623170.11885@localhost.localdomain>
 <20070706084910.4e5fc20f.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2007, Randy Dunlap wrote:

> On Fri, 6 Jul 2007 06:24:20 -0400 (EDT) Robert P. J. Day wrote:
>
> >
> > Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> >
> > ---
> >
> > diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
> > index 72464b5..4d65404 100644
> > --- a/drivers/usb/Makefile
> > +++ b/drivers/usb/Makefile
> > @@ -15,7 +15,6 @@ obj-$(CONFIG_USB_OHCI_HCD)	+= host/
> >  obj-$(CONFIG_USB_UHCI_HCD)	+= host/
> >  obj-$(CONFIG_USB_SL811_HCD)	+= host/
> >  obj-$(CONFIG_USB_U132_HCD)	+= host/
> > -obj-$(CONFIG_USB_OHCI_AT91)	+= host/
> >
> >  obj-$(CONFIG_USB_ACM)		+= class/
> >  obj-$(CONFIG_USB_PRINTER)	+= class/
> > --
>
> Please use subsystem mailing lists instead of using lkml for
> Everything:

that's what i would normally do, except a couple times when i did
that, i was chided for not posting to the main list.  i'll deal just
with the subsystem lists from now on.

rday

Return-Path: <linux-kernel-owner+w=401wt.eu-S1758358AbZIFUzf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758358AbZIFUzf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 16:55:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754282AbZIFUze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 16:55:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58862 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842AbZIFUze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 16:55:34 -0400
From: Christian =?utf-8?q?Kr=C3=A4mer?= <christian@kraemer-eu.de>
Organization: Privat
To: Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Date: Sun, 6 Sep 2009 22:54:48 +0200
User-Agent: KMail/1.9.9
Cc: Frans Pop <elendil@planet.nl>, linux-pcmcia@lists.infradead.org,
       Peter Stuge <peter@stuge.se>, linux-kernel@vger.kernel.org
References: <200909021856.29565.christian@kraemer-eu.de> <200909052146.10779.christian@kraemer-eu.de> <20090906174136.GA8224@pengutronix.de>
In-Reply-To: <20090906174136.GA8224@pengutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200909062254.48253.christian@kraemer-eu.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX19aoMYV/uK1bRUkRJGVQYKavPWqbSfb6MP+52T
 jx3MoTkeZF7NvHCtPgGgTq/e1JyqhgA9xIxf5yU9c1PM5MPGDY
 ncCyGv4YTF2h0iMlkbAADFDOurs46XR
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 06 September 2009 19:41:36 Wolfram Sang wrote:
> > > Uh oh. Which BIOS version do you have?
> >
> > The configuration interface displays: IBET41WW, 05/12/99.
> > I know this isn't the newest version, but I don't have a floppy device
> > for the laptop. I'll try to brun a dos cd with el torito folppy
> > emulation, maybe i can upgrade it this way.
>
> Given the various issues this laptop has, this is worthwhile, me thinks.

Yes, I'll try it. When the stuff with el torito won't work, I temporarily kill 
my swap partition and install the DOS from an old Windows 9x CD from the 
garret ;)

> > Strange, I'dont use a docking station. I have not even got one.
>
> Okay, then it is just a bay.
>

The laptop has a bay, thats right.

> > With regular PC Cards you mean 16 bit cards, don't you? I have only those
> > one wlan card, but i can try to organisate one.
>
> Yup, I mean those. That would sort out that the TI-Controller is broken.
> But there is more likely something wrong with the PCI-setup.

I can guarantee that the controller isn't broken. Before I installed the 
Gentoo (that is running on the laptop now) I installed my old Windows XP to 
look whether the hardware is broken. But therewith I could get It to work both 
with the original Atheros 5xxx driver and with the driver CD Proxim shipped 
with this card. So I'am sure, that exacly this card could work on this 
socket.

I don't know if it's permissible with the license issues, but If you think 
those information could help, I'll try to install it again and get those with 
the devicemanager.
This would take some time, but I could do it...

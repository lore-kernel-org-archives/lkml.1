Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXBVUAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXBVUAj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:00:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751815AbXBVUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:00:39 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:41334 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751816AbXBVUAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:00:37 -0500
Date: Thu, 22 Feb 2007 21:00:36 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Tilman Schmidt <tilman@imap.cc>, Hansjoerg Lipp <hjlipp@web.de>,
       gigaset307x-common@lists.sourceforge.net, kkeil@suse.de,
       kai.germaschewski@gmx.de, isdn4linux@listserv.isdn4linux.de,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] correct CONFIG_GIGASET_M101 Makefile entry
Message-ID: <20070222200036.GD8603@stusta.de>
References: <20070215215609.GH13958@stusta.de> <20070218163621.GA3945@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070218163621.GA3945@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 18, 2007 at 04:36:22PM +0000, Pavel Machek wrote:

> Hi!

Hi Pavel!

> > Advanced Mathematics, lesson 1:
> > 101 != 105
> > 
> > ;-)
> > 
> > Signed-off-by: Adrian Bunk <bunk@stusta.de>
> > 
> > ---
> > --- linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile.old	2007-02-15 17:38:23.000000000 +0100
> > +++ linux-2.6.20-mm1/drivers/isdn/gigaset/Makefile	2007-02-15 17:38:41.000000000 +0100
> > @@ -5,4 +5,4 @@
> >  
> >  obj-$(CONFIG_GIGASET_M105) += usb_gigaset.o gigaset.o
> >  obj-$(CONFIG_GIGASET_BASE) += bas_gigaset.o gigaset.o
> > -obj-$(CONFIG_GIGASET_M105) += ser_gigaset.o gigaset.o
> > +obj-$(CONFIG_GIGASET_M101) += ser_gigaset.o gigaset.o
> 
> Are you sure? M105 is both usb and serial?

You seem to read the patch in the wrong direction.  ;-)

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


Return-Path: <linux-kernel-owner+w=401wt.eu-S965533AbXBFVnY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965533AbXBFVnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 16:43:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965534AbXBFVnX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 16:43:23 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:34490 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965533AbXBFVnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 16:43:22 -0500
Date: Tue, 6 Feb 2007 21:42:58 +0000 (GMT)
From: James Simmons <jsimmons@infradead.org>
To: Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>
cc: Pavel Machek <pavel@ucw.cz>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Linux-fbdev-devel] [Cbe-oss-dev] [PATCH 0/7] RFC: Cell SPE
 logos
In-Reply-To: <1170641652.2620.89.camel@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702062141170.9224@pentafluge.infradead.org>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be>
 <20070204133212.GA2032@elf.ucw.cz> <1170641652.2620.89.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sun, 2007-02-04 at 14:32 +0100, Pavel Machek wrote:
> > Hi1
> > 
> > > I would like to hear your opinions about the patchset below (updated version
> > > compared to yesterday, lkml added to the CC list).
> > 
> > Can you just blast these pictures from userspace? There's really no
> > excuse to advertise SPEs from kernel....
> > 
> > What's next, I have powerful Intel graphics chipset in here, perhaps
> > it is as powerful as SPE, shall I start adding little pictures for its
> > pipelines?
> 
> By the same token, there is no excuse to have the logo code at all in
> the kernel in the first place... it's cool though :-) And it's a config
> option, so you don't have to have it....

True. Of course we would need a userland interface to splash a logo. I 
found the logo to be useful to know if the graphics device is alive and 
working properly.

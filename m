Return-Path: <linux-kernel-owner+w=401wt.eu-S965276AbXBGM7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965276AbXBGM7R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Feb 2007 07:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965563AbXBGM7R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Feb 2007 07:59:17 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2113 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965276AbXBGM7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Feb 2007 07:59:17 -0500
Date: Wed, 7 Feb 2007 12:44:08 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Linux Frame Buffer Device Development 
	<linux-fbdev-devel@lists.sourceforge.net>,
       James Simmons <jsimmons@infradead.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [Cbe-oss-dev] [PATCH 0/7] RFC: Cell SPE logos
Message-ID: <20070207124408.GE4481@ucw.cz>
References: <Pine.LNX.4.62.0701311325480.14996@pademelon.sonytel.be> <20070204133212.GA2032@elf.ucw.cz> <1170641652.2620.89.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1170641652.2620.89.camel@localhost.localdomain>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

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

I believe the old logo code was originally created for compatibility
with Solaris? :-).
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

Return-Path: <linux-kernel-owner+w=401wt.eu-S932839AbXBXQUl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839AbXBXQUl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Feb 2007 11:20:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933517AbXBXQUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Feb 2007 11:20:41 -0500
Received: from raven.upol.cz ([158.194.120.4]:39152 "EHLO raven.upol.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932839AbXBXQUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Feb 2007 11:20:40 -0500
Date: Sat, 24 Feb 2007 17:30:11 +0100
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: ioctls.h (Re: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.)
Message-ID: <20070224163011.GB16509@flower.upol.cz>
References: <Pine.LNX.4.64.0702240641520.15087@CPE00045a9c397f-CM001225dbafb6> <E1HKwCy-0005OM-FW@flower> <Pine.LNX.4.64.0702241058140.19099@CPE00045a9c397f-CM001225dbafb6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702241058140.19099@CPE00045a9c397f-CM001225dbafb6>
Organization: Palacky University in Olomouc, experimental physics department.
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 24, 2007 at 10:59:42AM -0500, Robert P. J. Day wrote:
> On Sat, 24 Feb 2007, Oleg Verych wrote:
> 
> > > From: "Robert P. J. Day"
> > > Newsgroups: gmane.linux.kernel
> > > Subject: [PATCH][RFC] Make asm-generic/ioctl.h extensible by adding conditionals.
> > > Date: Sat, 24 Feb 2007 06:45:20 -0500 (EST)
> >
> > >   as a followup to my earlier post, is it worth making this change
> > > to allow at least a couple arch-specific ioctl.h files to be
> > > massively simplified?
> >
> > And i wonder, why there is no generic ioctls.h, hm?
> 
> beats me, but it seems that there are a *number* of arch-specific
> header files that could be treated this way -- a single generic file,
> allowing the small number of customizations that seem to be necessary
> across all architectures.
> 
> but i figured i'd start with ioctl.h first and see where it went from
> there.

Indeed.

Thank you!

> -- 
> ========================================================================
> Robert P. J. Day
> Linux Consulting, Training and Annoying Kernel Pedantry
> Waterloo, Ontario, CANADA
> 
> http://fsdev.net/wiki/index.php?title=Main_Page
> ========================================================================
____

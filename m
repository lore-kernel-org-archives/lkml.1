Return-Path: <linux-kernel-owner+w=401wt.eu-S1753227AbXJGJtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227AbXJGJtk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 05:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbXJGJtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 05:49:32 -0400
Received: from agave.telenet-ops.be ([195.130.137.77]:53713 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbXJGJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 05:49:30 -0400
Date: Sun, 7 Oct 2007 11:49:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Oleg Verych <olecom@flower.upol.cz>
cc: Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if
 !CONFIG_SYSCTL)
In-Reply-To: <20071006220759.GJ22435@flower.upol.cz>
Message-ID: <Pine.LNX.4.64.0710071148340.8127@anakin>
References: <200709281005.34001.nickpiggin@yahoo.com.au>
 <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower>
 <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz>
 <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org>
 <20071006175145.GD22435@flower.upol.cz> <20071006185920.GA8005@uranus.ravnborg.org>
 <20071006204721.GF22435@flower.upol.cz> <20071006211048.GA8720@uranus.ravnborg.org>
 <20071006220759.GJ22435@flower.upol.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 7 Oct 2007, Oleg Verych wrote:
> On Sat, Oct 06, 2007 at 11:10:48PM +0200, Sam Ravnborg wrote:
> > On Sat, Oct 06, 2007 at 10:47:21PM +0200, Oleg Verych wrote:
> > > On Sat, Oct 06, 2007 at 08:59:20PM +0200, Sam Ravnborg wrote:
> > > > > Maintenance and acceptance of the m4/make/perl/C/ncurses community of my
> > > > > mainly `TERM=linux ; sed && sh' approach is more important for me.
> > > > 
> > > > There is noone having trouble with ncurses dependency today.
> > > 
> > > Who wants to meet a zombie anyway?
> > 
> > Finding quotes from old threads does not in any way prove your point.
> 
> This makes air hot for Roman. I want to prove my point not by words. But
> have to reply with something on my side, until i have work done.
> 
> []
> > And until now you have not given one single example of real
> > problems that will be solved by a total rewrite and cannot
> > be solved otherwise.
> 
> If you didn't see them in that, what i've posted, then i just have to
> say: i don't need to give anything. There are kvm, lguest, xen with ext2,
> ext3, xfs, etc. And there's no working alternative to build/config
> system. Thus, let me have my try OK? Thanks!

<ironic>
Let's add an alternative to the Makefiles, too....
</ironic>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

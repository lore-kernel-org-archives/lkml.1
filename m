Return-Path: <linux-kernel-owner+w=401wt.eu-S1763359AbXJFPMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763359AbXJFPMX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 11:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759460AbXJFPMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 11:12:15 -0400
Received: from barikada.upol.cz ([158.194.242.200]:43255 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759415AbXJFPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 11:12:13 -0400
Date: Sat, 6 Oct 2007 17:26:14 +0200
To: Roman Zippel <zippel@linux-m68k.org>
Cc: "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071006152614.GC22435@flower.upol.cz>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0710050408550.1819@scrub.home>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 05, 2007 at 04:35:41AM +0200, Roman Zippel wrote:
> Hi,
> 
> On Mon, 1 Oct 2007, Oleg Verych wrote:
> 
> > Today's kconfig was proposed and accepted in a very unpleasant
> > circumstances, has very poor design, development and no working
> > alternative (for 5+ years now).
> 
> If you want to make such statements, you have to offer a little more than 
> the hot air you're producing right now...
...

> If you want to improve the design, you're more than welcome. I'm the first 
> one to admit that there's still lots of room for improvement, but if you 
> want to claim this can only be done via a rewrite, then you have to be 
> a lot more specific what's wrong the current design and why it's 
> unfixable.
> Quite some thought has been put into this design and if you were a little 
> more specific, I could actually tell you why it is this way and maybe how 
> to improve it incrementally instead of trying to reinvent everything.

Thanks. I will be specific, after i will finish, what i already have,
to make air a bit less hot. Of course everything will be back
compatible, so nothing to worry about (the rewrite).
____

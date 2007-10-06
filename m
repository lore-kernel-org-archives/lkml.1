Return-Path: <linux-kernel-owner+w=401wt.eu-S1765003AbXJFS56@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765003AbXJFS56 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2007 14:57:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762883AbXJFS5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Oct 2007 14:57:52 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:43041 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762657AbXJFS5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2007 14:57:51 -0400
Date: Sat, 6 Oct 2007 20:59:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Oleg Verych <olecom@flower.upol.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071006185920.GA8005@uranus.ravnborg.org>
References: <20070918080537.GA14882@devil> <alpine.LFD.0.999.0709280728170.3579@woody.linux-foundation.org> <200709281005.34001.nickpiggin@yahoo.com.au> <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org> <20071006175145.GD22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006175145.GD22435@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Maintenance and acceptance of the m4/make/perl/C/ncurses community of my
> mainly `TERM=linux ; sed && sh' approach is more important for me.

There is noone having trouble with ncurses dependency today.
And perl is not yet mandatory for a kernel build expect
for a few architectures.
m4 is not used by the kernel - to my best knowledge.

	Sam

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753276AbXJHUUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753276AbXJHUUk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 16:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXJHUUc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 16:20:32 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:43430 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXJHUUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 16:20:32 -0400
Date: Mon, 8 Oct 2007 22:22:01 +0200
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
Message-ID: <20071008202201.GA16647@uranus.ravnborg.org>
References: <200709281112.52844.emgrasso@data-raptors.com> <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org> <20071006175145.GD22435@flower.upol.cz> <20071006185920.GA8005@uranus.ravnborg.org> <20071006204721.GF22435@flower.upol.cz> <20071006211048.GA8720@uranus.ravnborg.org> <20071006220759.GJ22435@flower.upol.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071006220759.GJ22435@flower.upol.cz>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> And there's no working alternative to build/config
> system. Thus, let me have my try OK? Thanks!

I would prefer if you used your time to do small incrmental improvements
to what we have today rather then rewriting from scratch.

But it's your decision and not mine.

	Sam

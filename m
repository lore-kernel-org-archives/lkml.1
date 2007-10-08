Return-Path: <linux-kernel-owner+w=401wt.eu-S1753375AbXJHVL0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbXJHVL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 17:11:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752223AbXJHVLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 17:11:18 -0400
Received: from barikada.upol.cz ([158.194.242.200]:51396 "EHLO
	barikada.upol.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbXJHVLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 17:11:17 -0400
Date: Mon, 8 Oct 2007 23:25:27 +0200
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       "Elyse M. Grasso" <emgrasso@data-raptors.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       kbuild-devel@lists.sourceforge.net,
       Andreas Herrmann <aherrman@arcor.de>
Subject: Re: A bit of kconfig rewrite (Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL)
Message-ID: <20071008212527.GZ22435@flower.upol.cz>
References: <E1IcFgK-0005oI-5p@flower> <Pine.LNX.4.64.0710050408550.1819@scrub.home> <20071006152614.GC22435@flower.upol.cz> <alpine.LFD.0.999.0710060900040.23684@woody.linux-foundation.org> <20071006175145.GD22435@flower.upol.cz> <20071006185920.GA8005@uranus.ravnborg.org> <20071006204721.GF22435@flower.upol.cz> <20071006211048.GA8720@uranus.ravnborg.org> <20071006220759.GJ22435@flower.upol.cz> <20071008202201.GA16647@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071008202201.GA16647@uranus.ravnborg.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Oleg Verych <olecom@flower.upol.cz>
Organization: Palacky University in Olomouc, experimental physics department
X-OS: x86_64-pc-linux-glibc-debian
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2007 at 10:22:01PM +0200, Sam Ravnborg wrote:
> > 
> > And there's no working alternative to build/config
> > system. Thus, let me have my try OK? Thanks!
> 
> I would prefer if you used your time to do small incrmental improvements
> to what we have today rather then rewriting from scratch.
> 
> But it's your decision and not mine.

In case anybody is interested:

Newsgroups: gmane.linux.kbuild.devel,gmane.linux.kernel
Subject: Re: [RFC/RFT] kbuild: save ARCH & CROSS_COMPILE
Date: Mon, 8 Oct 2007 22:50:48 +0200
Message-ID: <20071008205048.GY22435@flower.upol.cz>
Archived-At: <http://permalink.gmane.org/gmane.linux.kbuild.devel/1562>
____

Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbZGXPJp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbZGXPJp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 11:09:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752027AbZGXPJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 11:09:44 -0400
Received: from hera.kernel.org ([140.211.167.34]:32785 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751882AbZGXPJn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 11:09:43 -0400
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: eduardo.valentin@nokia.com
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       Hugo Villeneuve <hugo.villeneuve@lyrtech.com>,
       "philip@opensdr.com" <philip@opensdr.com>,
       Sascha Hauer <s.hauer@pengutronix.de>, Tony Lindgren <tony@atomide.com>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>, Ben Dooks <ben@simtec.co.uk>,
       dmitry pervushin <dpervushin@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arm <linux-arm@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090724144502.GA2622@esdhcp037198.research.nokia.com>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247076059.4382.127.camel@ht.satnam>
	 <20090708211321.GA15928@flint.arm.linux.org.uk>
	 <1247113711.2453.27.camel@ht.satnam>
	 <20090724144502.GA2622@esdhcp037198.research.nokia.com>
Content-Type: text/plain
Date: Fri, 24 Jul 2009 20:37:13 +0530
Message-Id: <1248448033.2429.17.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

On Fri, 2009-07-24 at 17:45 +0300, Eduardo Valentin wrote:
> On Thu, Jul 09, 2009 at 06:28:31AM +0200, ext Jaswinder Singh Rajput wrote:
> > On Wed, 2009-07-08 at 22:13 +0100, Russell King wrote:
> > > On Wed, Jul 08, 2009 at 11:30:59PM +0530, Jaswinder Singh Rajput wrote:
> > > > I am still waiting ACK/NAK for :
> > > > 
> > > >       includecheck fix: arm, misc.c
> > > >       includecheck fix: arm, atomic.h
> > > >       includecheck fix: arm, board-dm355-evm.c
> > > >       includecheck fix: arm, board-dm355-leopard.c
> > > >       includecheck fix: arm, board-dm644x-evm.c
> > > >       includecheck fix: arm, board-dm646x-evm.c
> > > >       includecheck fix: arm, board-sffsdr.c
> > > >       includecheck fix: arm, mach-mx3/devices.c
> > > >       includecheck fix: arm, mach-omap1/mcbsp.c
> > > >       includecheck fix: arm, mach-omap2/mcbsp.c
> > > >       includecheck fix: arm, plat-s3c64xx/pm.c
> > > >       includecheck fix: arm, plat-stmp3xxx/pinmux.c
> > > 
> > > You're still waiting because apparantly you never sent this set anywhere
> > > near any ARM people before.
> > > 
> > > For the first two, I'll ack them:
> > > 
> > > Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > > 
> > > The remainder look sane to me, but you'll have to seek acks from the
> > > individual platform maintainer(s).
> > > 
> > 
> > OK, adding some more ARM people and ARM lists to get remaining ACK/NAK.
> > 
> > Patches are already posted to LKML and also available at :
> > 
> > http://git.kernel.org/?p=linux/kernel/git/jaswinder/headers-check-2.6.git;a=summary
> > 
> > In case if you are not able to find these patches let me know.
> > 
> > Thanks,
> 
> In behalf of mach-omap[1,2]/mcbsp.c:
> 
> Acked-by: Eduardo Valentin <eduardo.valentin@nokia.com>
> 

These patches are still not applied anywhere, If you want you can apply
respective patch in your respective trees.

Thanks,
--
JSR


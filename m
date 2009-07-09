Return-Path: <linux-kernel-owner+w=401wt.eu-S1757722AbZGIEah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757722AbZGIEah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 00:30:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbZGIEa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 00:30:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:47003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751146AbZGIEa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 00:30:28 -0400
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       Hugo Villeneuve <hugo.villeneuve@lyrtech.com>, philip@opensdr.com,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Eduardo Valentin <eduardo.valentin@indt.org.br>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, Ben Dooks <ben@simtec.co.uk>,
       dmitry pervushin <dpervushin@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arm <linux-arm@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090708211321.GA15928@flint.arm.linux.org.uk>
References: <1247063308.4382.12.camel@ht.satnam>
	 <1247076059.4382.127.camel@ht.satnam>
	 <20090708211321.GA15928@flint.arm.linux.org.uk>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 09:58:31 +0530
Message-Id: <1247113711.2453.27.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-08 at 22:13 +0100, Russell King wrote:
> On Wed, Jul 08, 2009 at 11:30:59PM +0530, Jaswinder Singh Rajput wrote:
> > I am still waiting ACK/NAK for :
> > 
> >       includecheck fix: arm, misc.c
> >       includecheck fix: arm, atomic.h
> >       includecheck fix: arm, board-dm355-evm.c
> >       includecheck fix: arm, board-dm355-leopard.c
> >       includecheck fix: arm, board-dm644x-evm.c
> >       includecheck fix: arm, board-dm646x-evm.c
> >       includecheck fix: arm, board-sffsdr.c
> >       includecheck fix: arm, mach-mx3/devices.c
> >       includecheck fix: arm, mach-omap1/mcbsp.c
> >       includecheck fix: arm, mach-omap2/mcbsp.c
> >       includecheck fix: arm, plat-s3c64xx/pm.c
> >       includecheck fix: arm, plat-stmp3xxx/pinmux.c
> 
> You're still waiting because apparantly you never sent this set anywhere
> near any ARM people before.
> 
> For the first two, I'll ack them:
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> The remainder look sane to me, but you'll have to seek acks from the
> individual platform maintainer(s).
> 

OK, adding some more ARM people and ARM lists to get remaining ACK/NAK.

Patches are already posted to LKML and also available at :

http://git.kernel.org/?p=linux/kernel/git/jaswinder/headers-check-2.6.git;a=summary

In case if you are not able to find these patches let me know.

Thanks,
--
JSR



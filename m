Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbZGJFrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbZGJFrn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 01:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751095AbZGJFre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 01:47:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:33611 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbZGJFrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 01:47:31 -0400
Date: Fri, 10 Jul 2009 07:45:53 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Russell King <rmk+lkml@arm.linux.org.uk>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       davinci <davinci-linux-open-source@linux.davincidsp.com>,
       Hugo Villeneuve <hugo.villeneuve@lyrtech.com>, philip@opensdr.com,
       Eduardo Valentin <eduardo.valentin@indt.org.br>,
       Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
       Ben Dooks <ben-linux@fluff.org>, Ben Dooks <ben@simtec.co.uk>,
       dmitry pervushin <dpervushin@embeddedalley.com>,
       Vladislav Buzov <vbuzov@embeddedalley.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       arm <linux-arm@lists.arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/44] includecheck: fix multiple includes
Message-ID: <20090710054552.GS2714@pengutronix.de>
References: <1247063308.4382.12.camel@ht.satnam> <1247076059.4382.127.camel@ht.satnam> <20090708211321.GA15928@flint.arm.linux.org.uk> <1247113711.2453.27.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247113711.2453.27.camel@ht.satnam>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 07:45:01 up 59 days, 20:09, 13 users,  load average: 0.06, 0.04,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 09, 2009 at 09:58:31AM +0530, Jaswinder Singh Rajput wrote:
> On Wed, 2009-07-08 at 22:13 +0100, Russell King wrote:
> > On Wed, Jul 08, 2009 at 11:30:59PM +0530, Jaswinder Singh Rajput wrote:
> > > I am still waiting ACK/NAK for :
> > > 
> > >       includecheck fix: arm, misc.c
> > >       includecheck fix: arm, atomic.h
> > >       includecheck fix: arm, board-dm355-evm.c
> > >       includecheck fix: arm, board-dm355-leopard.c
> > >       includecheck fix: arm, board-dm644x-evm.c
> > >       includecheck fix: arm, board-dm646x-evm.c
> > >       includecheck fix: arm, board-sffsdr.c
> > >       includecheck fix: arm, mach-mx3/devices.c
> > >       includecheck fix: arm, mach-omap1/mcbsp.c
> > >       includecheck fix: arm, mach-omap2/mcbsp.c
> > >       includecheck fix: arm, plat-s3c64xx/pm.c
> > >       includecheck fix: arm, plat-stmp3xxx/pinmux.c

For mach-mx3/devices.c:

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

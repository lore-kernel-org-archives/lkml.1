Return-Path: <linux-kernel-owner+w=401wt.eu-S1753722AbZHXWGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbZHXWGZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 18:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753560AbZHXWGX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 18:06:23 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51173 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbZHXWGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 18:06:22 -0400
Date: Mon, 24 Aug 2009 23:06:13 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tony Lindgren <tony@atomide.com>
Cc: Jarkko Nikula <jhnikula@gmail.com>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Message-ID: <20090824220612.GB4338@sirena.org.uk>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl>
 <200908231945.40187.jkrzyszt@tis.icnet.pl>
 <20090823180543.GA6167@opensource.wolfsonmicro.com>
 <200908232038.05593.jkrzyszt@tis.icnet.pl>
 <20090823184943.GA6994@opensource.wolfsonmicro.com>
 <20090824084920.c99c561a.jhnikula@gmail.com>
 <20090824124902.GH7069@atomide.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824124902.GH7069@atomide.com>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [alsa-devel] [RFC][PATCH 1/3 v2] ARM: OMAP: DMA: Add support
 for DMA channel self linking on OMAP1510
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 03:49:03PM +0300, Tony Lindgren wrote:

> > We should remember that arch/arm/plat-omap/mcbsp.c changes done via
> > ALSA tree has been an exception and that's only for simpler procedure.
> > McBSP is not so critical if sources goes out-of-sync but DMA is.

> Sorry for the delay in replying. I'm OK for these to go in via the alsa
> tree as there are not currently other patches pending in the mcbsp or
> dma area for omap. So I think it's better merge all the audio related
> patches together in this case.

Applied, thanks.

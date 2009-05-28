Return-Path: <linux-kernel-owner+w=401wt.eu-S1758198AbZE1KeB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198AbZE1KeB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:34:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754583AbZE1Kdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:33:54 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36896 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754083AbZE1Kdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:33:53 -0400
Date: Thu, 28 May 2009 12:33:35 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, devicetree-discuss@ozlabs.org,
       linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, scottwood@freescale.com,
       yuan-bo.ye@motorola.com, timur@freescale.com
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528103335.GW6805@pengutronix.de>
References: <20090527175609.GB31861@flint.arm.linux.org.uk> <1243496236.3171.140.camel@pasglop> <20090528091513.GA14789@n2100.arm.linux.org.uk> <20090528.025739.16559619.davem@davemloft.net> <1243505493.5573.29.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1243505493.5573.29.camel@pasglop>
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
X-Uptime: 12:23:13 up 90 days, 20:05,  6 users,  load average: 0.04, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 08:11:33PM +1000, Benjamin Herrenschmidt wrote:
> The possibilities are endless. _BUT_ it does require some careful
> thinking to get things right. To that extent, I do agree with Russell
> that rather than a "violent" conversion, ARM should first try things out
> as an opt-in for a few platforms and see how it goes.

I think that the overall discussion goes into a very good direction.

The level of agreement is not as low as it might look like, I agree with
most of what David Gibson, benh and rmk have said so far; the problems
we've seen have been well identified. In the end it's probably a matter
of finding enough time to actually implement for example a prototype for
PXA.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

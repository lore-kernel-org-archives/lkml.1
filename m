Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbZE1KNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbZE1KNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 06:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbZE1KNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 06:13:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50245 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbZE1KNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 06:13:42 -0400
Date: Thu, 28 May 2009 12:13:40 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Wolfgang Denk <wd@denx.de>
Cc: Grant Likely <grant.likely@secretlab.ca>,
       Robert Schwebel <r.schwebel@pengutronix.de>,
       Scott Wood <scottwood@freescale.com>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       Janboe Ye <yuan-bo.ye@motorola.com>, Timur Tabi <timur@freescale.com>,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528101339.GV6805@pengutronix.de>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <fa686aa40905270839m375bbdacqb1acb1be0a2d2da0@mail.gmail.com> <20090527162000.GM6805@pengutronix.de> <fa686aa40905271335o1165419hda2334bef42aa3f@mail.gmail.com> <20090527234801.GP6805@pengutronix.de> <4A1DD3A0.3010501@freescale.com> <20090528000707.GR6805@pengutronix.de> <fa686aa40905272029n32aa5f1ds86d07f0de4894815@mail.gmail.com> <20090528095126.99DB4832E416@gemini.denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20090528095126.99DB4832E416@gemini.denx.de>
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
X-Uptime: 12:06:43 up 90 days, 19:48,  5 users,  load average: 0.03, 0.12,
	0.06
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 28, 2009 at 11:51:26AM +0200, Wolfgang Denk wrote:
> True. From a commercial point of view this is a huge  problem  casued
> by the device tree - custumers who used to oder a BSP from commercial
> service providers (like Robert or me :-) now often find that all they
> need  to  do is to tweak the device tree to get their system running.
> Lost business. D*mn...  [Maybe this explains Robert's reluctance?]

Wolfgang, you know me long enough to realize that this argument is
*crap*.

Talking about business cases, it has turned out to be extremely
difficult to explain customers that the effort for the actual
functionality is only a little percentage of the work necessary to do
the oftree stuff right. The functionality has often worked after a few
hours, and until all oftrees have been solved, it often takes weeks.

In result, this has already led to customers concluding that

- mainline is not worth the effort
- linux is overkill and one should better use cortex-bare-metal

However, that is only our personal observation.

rsc
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752675AbXKJNlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675AbXKJNlV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 08:41:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbXKJNlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 08:41:15 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:44894 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbXKJNlO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 08:41:14 -0500
Date: Sat, 10 Nov 2007 14:40:48 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Paul Mundt <lethal@linux-sh.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org
Message-ID: <20071110134048.GR8087@pengutronix.de>
References: <20071110080629.GA18520@linux-sh.org> <20071110091057.GA10446@flint.arm.linux.org.uk> <20071110112632.GQ8087@pengutronix.de> <20071110114953.GL26163@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071110114953.GL26163@stusta.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 14:40:01 up 221 days,  7:05, 17 users,  load average: 0.15, 0.14, 0.15
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: ARM defconfig bogosity in current git
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 10, 2007 at 12:49:53PM +0100, Adrian Bunk wrote:
> > Aaargh, that came from a broken script changing the patch from p0 to p1...
> > Please simply revert that patch, I'll send a new and correct one.
>
> You should also check what you sent - the contents of this file was 
> exactly the same as arch/arm/configs/netx_defconfig is since one year.

/me puts on his brown paper bag. Patch follows.

Robert
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9


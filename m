Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZFISav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZFISav (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 14:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZFISao
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 14:30:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44018 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752001AbZFISan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 14:30:43 -0400
Date: Tue, 9 Jun 2009 20:29:40 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Oskar Schirmer <os@emlix.com>
Cc: Sascha Hauer <kernel@pengutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: imx: serial: add IrDA support to serial driver
Message-ID: <20090609182939.GC32355@pengutronix.de>
References: <1244555211-15618-1-git-send-email-os@emlix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1244555211-15618-1-git-send-email-os@emlix.com>
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
X-Uptime: 20:27:33 up 29 days,  8:51, 15 users,  load average: 0.08, 0.04,
	0.01
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oskar,

On Tue, Jun 09, 2009 at 03:46:43PM +0200, Oskar Schirmer wrote:
> 
> Using the iMX serial driver with an IrDA device
> needs extra peripheral settings and specific
> timing depending on the transmitter circuitry used.
> 
> The first five patches fix minor problems in the
> generic part of the iMX serial driver
> 
> The sixth introduces a generic function to calculate optimum
> numerator denominator value pairs for PLL and clock
> register settings, the seventh patch uses this function
> in the iMX serial driver.
> 
> The last patch finally adds IrDA support to the iMX serial driver.
> 

Out of interest: On which i.MX type system(s) did you test the
IRDA support?

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

Return-Path: <linux-kernel-owner+w=401wt.eu-S1761903AbXLNUDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761903AbXLNUDn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 15:03:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751723AbXLNUDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 15:03:34 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:45157 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751410AbXLNUDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 15:03:33 -0500
Date: Fri, 14 Dec 2007 21:03:18 +0100
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Adrian Bunk <bunk@kernel.org>
Cc: hskinnemoen@atmel.com, linux-kernel@vger.kernel.org
Message-ID: <20071214200318.GM3851@pengutronix.de>
References: <20071213195617.GF21616@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071213195617.GF21616@stusta.de>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 21:02:39 up 28 days, 22:54, 10 users,  load average: 0.17, 0.25, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: rsc@pengutronix.de
Subject: Re: Working upstream toolchain for avr32?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2007 at 08:56:17PM +0100, Adrian Bunk wrote:
> AFAIK the latest available AVR32 toolchains are some patched gcc 4.0 and 
> some patched binutils 2.17, and avr32 is currently the only architecture 
> in the kernel where upstream of both of them is not capable of building 
> a kernel for the architecture.

Is an upstream toolchain available which is able to build blackfin?

rsc
-- 
 Dipl.-Ing. Robert Schwebel | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9


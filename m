Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab0BEGsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 01:48:13 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50397 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933055Ab0BEGsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 01:48:11 -0500
Date: Fri, 5 Feb 2010 07:48:09 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
       valentin.longchamp@epfl.ch, daniel@caiaq.de, grant.likely@secretlab.ca,
       Dinh.Nguyen@freescale.com, r.herring@freescale.com,
       bryan.wu@canonical.com
Subject: Re: [PATCHv2 11/11] mxc: Add imx51_defconfig
Message-ID: <20100205064809.GZ6130@pengutronix.de>
References: <cover.1265173480.git.amit.kucheria@canonical.com> <23d720d71fcb0d088fa1829fccaa4823090e1346.1265173480.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23d720d71fcb0d088fa1829fccaa4823090e1346.1265173480.git.amit.kucheria@canonical.com>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Industrial Linux Solutions Handelsregister:
	Amtsgericht Hildesheim, HRA 2686 Peiner Strasse 6-8, 31137
	Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 07:46:41 up 115 days, 19:35, 33 users,  load average: 0.05, 0.36,
	0.95
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amit,

On Tue, Feb 02, 2010 at 09:16:33PM -0800, Amit Kucheria wrote:
> This config is used to test the base support for i.MX51 processors on the
> Babbage board
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/configs/imx51_defconfig | 1286 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 1286 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/configs/imx51_defconfig

Can you rename this to mx51_defconfig? All other i.MX defconfigs begin
with mx.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

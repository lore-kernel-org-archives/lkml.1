Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbZF2HNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbZF2HNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 03:13:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753037AbZF2HNn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 03:13:43 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54585 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbZF2HNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 03:13:42 -0400
Date: Mon, 29 Jun 2009 09:12:31 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Sascha Hauer <kernel@pengutronix.de>,
       linux-fbdev-devel@lists.sourceforge.net
Subject: Re: [PATCH 50/62] drivers/video/imxfb.c: Remove unnecessary
	semicolons
Message-ID: <20090629071231.GJ31396@pengutronix.de>
References: <cover.1246173664.git.joe@perches.com> <b3809f274f910612520e30bc4a53d4fcb905771c.1246173683.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3809f274f910612520e30bc4a53d4fcb905771c.1246173683.git.joe@perches.com>
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
X-Uptime: 09:11:58 up 48 days, 21:36, 13 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 28, 2009 at 09:26:55AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>


> ---
>  drivers/video/imxfb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index 15a0ee6..89e6f1e 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -677,7 +677,7 @@ static int __init imxfb_probe(struct platform_device *pdev)
>  
>  	fbi->clk = clk_get(&pdev->dev, NULL);
>  	if (IS_ERR(fbi->clk)) {
> -		ret = PTR_ERR(fbi->clk);;
> +		ret = PTR_ERR(fbi->clk);
>  		dev_err(&pdev->dev, "unable to get clock: %d\n", ret);
>  		goto failed_getclock;
>  	}
> -- 
> 1.6.3.1.10.g659a0.dirty
> 
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

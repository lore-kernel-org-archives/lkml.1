Return-Path: <linux-kernel-owner+w=401wt.eu-S1753109AbXBKGbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbXBKGbh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 01:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753112AbXBKGbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 01:31:36 -0500
Received: from trinity.fluff.org ([217.147.94.151]:4812 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753109AbXBKGbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 01:31:36 -0500
Date: Sun, 11 Feb 2007 06:31:24 +0000
To: Nicolas Kaiser <nikai@nikai.net>
Cc: linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
       trivial@kernel.org
Subject: Re: arch/arm: typos in KERN_ERR, KERN_INFO
Message-ID: <20070211063123.GE27779@trinity.fluff.org>
References: <20070210021431.21722175@lucky.kitzblitz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070210021431.21722175@lucky.kitzblitz>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
From: Ben Dooks <ben@trinity.fluff.org>
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 10, 2007 at 02:14:31AM +0100, Nicolas Kaiser wrote:
> Typos in KERN_ERR, KERN_INFO.
> 
> Signed-off-by: Nicolas Kaiser <nikai@nikai.net>
> ---
> 
>  arch/arm/mach-imx/dma.c           |    2 +-
>  arch/arm/mach-s3c2410/pm-simtec.c |    2 +-
>  arch/arm/plat-omap/dma.c          |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Thanks for the spot.

arch/arm/mach-s3c2410 is being reorganised, so can we split this
patch and have the other two submitted, or wait for the re-work
has made it through to the kernel please?
 
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.


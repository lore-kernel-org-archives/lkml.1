Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbZGCKrW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbZGCKrW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:47:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZGCKrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:47:15 -0400
Received: from mga05.intel.com ([192.55.52.89]:30243 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751892AbZGCKrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:47:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,341,1243839600"; 
   d="scan'208";a="704776437"
Date: Fri, 3 Jul 2009 12:49:15 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Add entry for Wolfson PMIC drivers
Message-ID: <20090703104913.GC4176@sortiz.org>
References: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 04:43:08PM +0100, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Applied, thanks Mark.

Cheers,
Samuel.

> ---
>  MAINTAINERS |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index cf4abdd..b9a1e2d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6278,6 +6278,24 @@ S:	Supported
>  F:	drivers/input/touchscreen/*wm97*
>  F:	include/linux/wm97xx.h
>  
> +WOLFSON MICROELECTRONICS PMIC DRIVERS
> +P:	Mark Brown
> +M:	broonie@opensource.wolfsonmicro.com
> +L:	linux-kernel@vger.kernel.org
> +T:	git git://opensource.wolfsonmicro.com/linux-2.6-audioplus
> +W:	http://opensource.wolfsonmicro.com/node/8
> +S:	Supported
> +F:	drivers/leds/leds-wm83*.c
> +F:	drivers/mfd/wm8*.c
> +F:	drivers/power/wm83*.c
> +F:	drivers/rtc/rtc-wm83*.c
> +F:	drivers/regulator/wm8*.c
> +F:	drivers/watchdog/wm83*_wdt.c
> +F:	include/linux/mfd/wm8350/
> +F:	include/linux/mfd/wm8400/
> +F:	sound/soc/codecs/wm8350.c
> +F:	sound/soc/codecs/wm8400.c
> +
>  X.25 NETWORK LAYER
>  P:	Henner Eisen
>  M:	eis@baty.hanse.de
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

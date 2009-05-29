Return-Path: <linux-kernel-owner+w=401wt.eu-S1757772AbZE2KrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbZE2KrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 06:47:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754505AbZE2Kqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 06:46:54 -0400
Received: from mga05.intel.com ([192.55.52.89]:61346 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754039AbZE2Kqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 06:46:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,270,1241420400"; 
   d="scan'208";a="694618046"
Date: Fri, 29 May 2009 12:49:04 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Fix Kconfig help text for WM8350
Message-ID: <20090529104903.GC892@sortiz.org>
References: <1243593258-10378-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1243593258-10378-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 29, 2009 at 11:34:18AM +0100, Mark Brown wrote:
> More with the grammar.
Thanks Mark, applied to my for-next branch.

Cheers,
Samuel.

 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 9554554..5d0e926 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -152,7 +152,7 @@ config MFD_WM8400
>  	depends on I2C
>  	help
>  	  Support for the Wolfson Microelecronics WM8400 PMIC and audio
> -	  CODEC.  This driver adds provides common support for accessing
> +	  CODEC.  This driver provides common support for accessing
>  	  the device, additional drivers must be enabled in order to use
>  	  the functionality of the device.
>  
> -- 
> 1.6.3.1
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

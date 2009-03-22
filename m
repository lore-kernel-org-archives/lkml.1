Return-Path: <linux-kernel-owner+w=401wt.eu-S1756581AbZCVW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756581AbZCVW4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756152AbZCVW4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 18:56:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:3145 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492AbZCVW4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 18:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,403,1233561600"; 
   d="scan'208";a="499906784"
Date: Sun, 22 Mar 2009 23:58:13 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Huang Weiyi <weiyi.huang@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: remove duplicated #include
Message-ID: <20090322225812.GA2888@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1237614569-3548-1-git-send-email-weiyi.huang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237614569-3548-1-git-send-email-weiyi.huang@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Huang,

On Sat, Mar 21, 2009 at 01:49:29PM +0800, Huang Weiyi wrote:
> Remove duplicated #include in drivers/mfd/pcf50633-core.c.
This one is already applied to my next tree, thanks.

Cheers,
Samuel.

> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> ---
>  drivers/mfd/pcf50633-core.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/pcf50633-core.c b/drivers/mfd/pcf50633-core.c
> index 2e36057..7793932 100644
> --- a/drivers/mfd/pcf50633-core.c
> +++ b/drivers/mfd/pcf50633-core.c
> @@ -15,7 +15,6 @@
>  #include <linux/kernel.h>
>  #include <linux/device.h>
>  #include <linux/sysfs.h>
> -#include <linux/device.h>
>  #include <linux/module.h>
>  #include <linux/types.h>
>  #include <linux/interrupt.h>
> -- 
> 1.6.0.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/

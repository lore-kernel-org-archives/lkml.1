Return-Path: <linux-kernel-owner+w=401wt.eu-S1757306AbZEUWQW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306AbZEUWQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:16:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756307AbZEUWQK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:16:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756290AbZEUWQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:16:08 -0400
Date: Fri, 22 May 2009 00:16:05 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Daniel Mack <daniel@caiaq.de>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] misc: Fix typo in Kconfig
In-Reply-To: <1242928473-5633-1-git-send-email-abogani@texware.it>
Message-ID: <alpine.LNX.2.00.0905220015380.13917@wotan.suse.de>
References: <alpine.LNX.2.00.0904151200400.13028@wotan.suse.de> <1242928473-5633-1-git-send-email-abogani@texware.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 May 2009, Alessio Igor Bogani wrote:

> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> ---
>  drivers/input/misc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 5c0a631..06f46fc 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -232,7 +232,7 @@ config INPUT_GPIO_ROTARY_ENCODER
>  	depends on GPIOLIB && GENERIC_GPIO
>  	help
>  	  Say Y here to add support for rotary encoders connected to GPIO lines.
> -	  Check file:Documentation/incput/rotary_encoder.txt for more
> +	  Check file:Documentation/input/rotary-encoder.txt for more
>  	  information.

Applied, thanks Alessio.

-- 
Jiri Kosina
SUSE Labs

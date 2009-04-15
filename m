Return-Path: <linux-kernel-owner+w=401wt.eu-S1756960AbZDOKBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756960AbZDOKBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZDOKBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:01:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:46354 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbZDOKBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:01:24 -0400
Date: Wed, 15 Apr 2009 12:01:23 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Daniel Mack <daniel@caiaq.de>, LKML <linux-kernel@vger.kernel.org>,
       Trivial <trivial@kernel.org>
Subject: Re: [PATCH] misc: Fix typo in Kconfig
In-Reply-To: <1239705262-6415-1-git-send-email-abogani@texware.it>
Message-ID: <alpine.LNX.2.00.0904151200400.13028@wotan.suse.de>
References: <1239705262-6415-1-git-send-email-abogani@texware.it>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009, Alessio Igor Bogani wrote:

> Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
> ---
>  drivers/input/misc/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> index 203abac..674f755 100644
> --- a/drivers/input/misc/Kconfig
> +++ b/drivers/input/misc/Kconfig
> @@ -232,7 +232,7 @@ config INPUT_GPIO_ROTARY_ENCODER
>  	depends on GPIOLIB && GENERIC_GPIO
>  	help
>  	  Say Y here to add support for rotary encoders connected to GPIO lines.
> -	  Check file:Documentation/incput/rotary_encoder.txt for more
> +	  Check file:Documentation/input/rotary_encoder.txt for more
>  	  information.

It's still not quite correct, the filename in current tree is 
file:Documentation/input/rotary-encoder.txt :)

-- 
Jiri Kosina
SUSE Labs

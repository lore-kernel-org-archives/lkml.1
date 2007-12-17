Return-Path: <linux-kernel-owner+w=401wt.eu-S933012AbXLQUcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbXLQUcd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:32:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758244AbXLQUcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:32:25 -0500
Received: from smtp-101-monday.noc.nerim.net ([62.4.17.101]:1560 "EHLO
	mallaury.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758178AbXLQUcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:32:24 -0500
Date: Mon, 17 Dec 2007 21:32:22 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       i2c@lm-sensors.org
Subject: Re: [PATCH] drivers/i2c/: Spelling fixes
Message-ID: <20071217213222.09350886@hyperion.delvare>
In-Reply-To: <1197919875-5288-35-git-send-email-joe@perches.com>
References: <1197919875-5288-35-git-send-email-joe@perches.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Mon, 17 Dec 2007 11:30:34 -0800, Joe Perches wrote:
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/i2c/busses/i2c-at91.c     |    2 +-
>  drivers/i2c/busses/i2c-powermac.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
> index 9c8b6d5..c09b036 100644
> --- a/drivers/i2c/busses/i2c-at91.c
> +++ b/drivers/i2c/busses/i2c-at91.c
> @@ -135,7 +135,7 @@ static int xfer_write(struct i2c_adapter *adap, unsigned char *buf, int length)
>   * Generic i2c master transfer entrypoint.
>   *
>   * Note: We do not use Atmel's feature of storing the "internal device address".
> - * Instead the "internal device address" has to be written using a seperate
> + * Instead the "internal device address" has to be written using a separate
>   * i2c message.
>   * http://lists.arm.linux.org.uk/pipermail/linux-arm-kernel/2004-September/024411.html
>   */
> diff --git a/drivers/i2c/busses/i2c-powermac.c b/drivers/i2c/busses/i2c-powermac.c
> index 0ab4f26..7813127 100644
> --- a/drivers/i2c/busses/i2c-powermac.c
> +++ b/drivers/i2c/busses/i2c-powermac.c
> @@ -94,7 +94,7 @@ static s32 i2c_powermac_smbus_xfer(	struct i2c_adapter*	adap,
>  	    	break;
>  
>  	/* Note that these are broken vs. the expected smbus API where
> -	 * on reads, the lenght is actually returned from the function,
> +	 * on reads, the length is actually returned from the function,
>  	 * but I think the current API makes no sense and I don't want
>  	 * any driver that I haven't verified for correctness to go
>  	 * anywhere near a pmac i2c bus anyway ...

Applied, thank you.

-- 
Jean Delvare

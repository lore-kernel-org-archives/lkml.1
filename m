Return-Path: <linux-kernel-owner+w=401wt.eu-S936271AbXLQUki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936271AbXLQUki (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:40:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757143AbXLQUk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 15:40:29 -0500
Received: from c60.cesmail.net ([216.154.195.49]:53353 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756429AbXLQUk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 15:40:28 -0500
Subject: Re: [PATCH] drivers/net/: Spelling fixes
From: Pavel Roskin <proski@gnu.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
References: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Content-Type: text/plain
Date: Mon, 17 Dec 2007 15:40:25 -0500
Message-Id: <1197924025.2541.11.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2007-12-17 at 11:40 -0800, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

> diff --git a/drivers/net/wireless/orinoco.h
> b/drivers/net/wireless/orinoco.h
> index 4720fb2..703a4cf 100644
> --- a/drivers/net/wireless/orinoco.h
> +++ b/drivers/net/wireless/orinoco.h
> @@ -108,7 +108,7 @@ struct orinoco_private {
>  	int	scan_inprogress;	/* Scan pending... */
>  	u32	scan_mode;		/* Type of scan done */
>  	char *	scan_result;		/* Result of previous scan */
> -	int	scan_len;		/* Lenght of result */
> +	int	scan_len;		/* Length of result */
>  };
>  
>  #ifdef ORINOCO_DEBUG

Acked-by: Pavel Roskin <proski@gnu.org>

Actually, I don't think such minor comment fixes need to be reviewed by
the maintainers.  Thanks anyway.

-- 
Regards,
Pavel Roskin

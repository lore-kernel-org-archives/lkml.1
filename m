Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934138Ab0CNVVA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Mar 2010 17:21:00 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:51151 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab0CNVU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Mar 2010 17:20:57 -0400
Date: Mon, 15 Mar 2010 08:20:55 +1100
From: Simon Horman <horms@verge.net.au>
To: Steven Harms <sjharms@gmail.com>
Cc: gregkh@suse.de, bobby.prani@gmail.com, sharms@ubuntu.com,
       dcb314@hotmail.com, a.beregalov@gmail.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: otus: Remove mix of tabs and spaces with just
 tabs in ioctl.c
Message-ID: <20100314212055.GC5893@verge.net.au>
References: <1268582160-8713-1-git-send-email-sharms@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268582160-8713-1-git-send-email-sharms@ubuntu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 11:56:00AM -0400, Steven Harms wrote:
> Previously defines had a mix of both tabs and spaces, causing an error in the checkpatch tool.  These tabs and spaces have been consolidated to only tabs.
> Signed-off-by: Steven Harms <sharms@ubuntu.com>

Looks good to me.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
>  drivers/staging/otus/ioctl.c |   30 +++++++++++++++---------------
>  1 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/staging/otus/ioctl.c b/drivers/staging/otus/ioctl.c
> index 8c47b1a..963d807 100644
> --- a/drivers/staging/otus/ioctl.c
> +++ b/drivers/staging/otus/ioctl.c
> @@ -29,34 +29,34 @@
> 
>  #include "usbdrv.h"
> 
> -#define ZD_IOCTL_WPA			    (SIOCDEVPRIVATE + 1)
> -#define ZD_IOCTL_PARAM			    (SIOCDEVPRIVATE + 2)
> -#define ZD_IOCTL_GETWPAIE		    (SIOCDEVPRIVATE + 3)
> +#define ZD_IOCTL_WPA			(SIOCDEVPRIVATE + 1)
> +#define ZD_IOCTL_PARAM			(SIOCDEVPRIVATE + 2)
> +#define ZD_IOCTL_GETWPAIE		(SIOCDEVPRIVATE + 3)
>  #ifdef ZM_ENABLE_CENC
> -#define ZM_IOCTL_CENC               (SIOCDEVPRIVATE + 4)
> +#define ZM_IOCTL_CENC			(SIOCDEVPRIVATE + 4)
>  #endif  /* ZM_ENABLE_CENC */
> -#define ZD_PARAM_ROAMING		    0x0001
> -#define ZD_PARAM_PRIVACY		    0x0002
> -#define ZD_PARAM_WPA			    0x0003
> +#define ZD_PARAM_ROAMING		0x0001
> +#define ZD_PARAM_PRIVACY		0x0002
> +#define ZD_PARAM_WPA			0x0003
>  #define ZD_PARAM_COUNTERMEASURES	0x0004
>  #define ZD_PARAM_DROPUNENCRYPTED	0x0005
> -#define ZD_PARAM_AUTH_ALGS		    0x0006
> -#define ZD_PARAM_WPS_FILTER		    0x0007
> +#define ZD_PARAM_AUTH_ALGS		0x0006
> +#define ZD_PARAM_WPS_FILTER		0x0007
> 
>  #ifdef ZM_ENABLE_CENC
>  #define P80211_PACKET_CENCFLAG		0x0001
>  #endif  /* ZM_ENABLE_CENC */
> -#define P80211_PACKET_SETKEY     	0x0003
> +#define P80211_PACKET_SETKEY		0x0003
> 
>  #define ZD_CMD_SET_ENCRYPT_KEY		0x0001
> -#define ZD_CMD_SET_MLME			    0x0002
> -#define ZD_CMD_SCAN_REQ			    0x0003
> +#define ZD_CMD_SET_MLME			0x0002
> +#define ZD_CMD_SCAN_REQ			0x0003
>  #define ZD_CMD_SET_GENERIC_ELEMENT	0x0004
> -#define ZD_CMD_GET_TSC			    0x0005
> +#define ZD_CMD_GET_TSC			0x0005
> 
>  #define ZD_CRYPT_ALG_NAME_LEN		16
> -#define ZD_MAX_KEY_SIZE			    32
> -#define ZD_MAX_GENERIC_SIZE		    64
> +#define ZD_MAX_KEY_SIZE			32
> +#define ZD_MAX_GENERIC_SIZE		64
> 
>  #include <net/iw_handler.h>
> 
> --
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

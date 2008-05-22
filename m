Return-Path: <linux-kernel-owner+w=401wt.eu-S936618AbYEVKXB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936618AbYEVKXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 06:23:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S936725AbYEVKWU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 06:22:20 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59326 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936646AbYEVKWS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 06:22:18 -0400
Message-ID: <48354958.2060905@garzik.org>
Date: Thu, 22 May 2008 06:22:16 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Huang Weiyi <weiyi.huang@gmail.com>
Subject: Re: [PATCH 1/1] Blackfin EMAC Driver: Removed duplicated include
 <linux/ethtool.h> in drivers/net/bfin_mac.c.
References: <1210565644-4272-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1210565644-4272-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Huang Weiyi <weiyi.huang@gmail.com>
> 
> Signed-off-by: Huang Weiyi <weiyi.huang@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/net/bfin_mac.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/bfin_mac.c b/drivers/net/bfin_mac.c
> index 89c0018..4144343 100644
> --- a/drivers/net/bfin_mac.c
> +++ b/drivers/net/bfin_mac.c
> @@ -22,7 +22,6 @@
>  #include <linux/crc32.h>
>  #include <linux/device.h>
>  #include <linux/spinlock.h>
> -#include <linux/ethtool.h>
>  #include <linux/mii.h>
>  #include <linux/phy.h>

applied



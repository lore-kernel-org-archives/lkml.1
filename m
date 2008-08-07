Return-Path: <linux-kernel-owner+w=401wt.eu-S1752845AbYHGMV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845AbYHGMV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 08:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751524AbYHGMVE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 08:21:04 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:18137
	"EHLO VA3EHSOBE001.bigfish.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751245AbYHGMU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 08:20:58 -0400
X-BigFish: VPS-16(zz1432R98dR936eQ62a3L1805Mzz10d3izzz32i6bh87il62h)
X-Spam-TCS-SCL: 1:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K585WC-01-9A0-01
Date: Thu, 7 Aug 2008 11:47:58 +0200
From: Robert Richter <robert.richter@amd.com>
To: "Gustavo F. Padovan" <gustavo@las.ic.unicamp.br>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH 02/24] x86: kernel/apm_32.c cleanup
Message-ID: <20080807094754.GA32164@erda.amd.com>
References: <gustavo@las.ic.unicamp.br> <1217279371-4410-1-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-2-git-send-email-gustavo@las.ic.unicamp.br> <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1217279371-4410-3-git-send-email-gustavo@las.ic.unicamp.br>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 07 Aug 2008 09:48:13.0744 (UTC) FILETIME=[B5A3F300:01C8F872]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.07.08 18:09:09, Gustavo F. Padovan wrote:
> Remove additional whitespaces and tabs.
> 
> Signed-off-by: Gustavo F. Padovan <gustavo@las.ic.unicamp.br>
> ---
>  arch/x86/kernel/apm_32.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
> index 9ee24e6..b0c049c 100644
> --- a/arch/x86/kernel/apm_32.c
> +++ b/arch/x86/kernel/apm_32.c
> @@ -435,7 +435,7 @@ static const char * const apm_event_name[] = {
>  
>  typedef struct lookup_t {
>  	int	key;
> -	char 	*msg;
> +	char *msg;

Shouldn't this be a tab?

>  } lookup_t;
>  
>  /*
> @@ -1679,8 +1679,8 @@ static int apm(void *unused)
>  	unsigned short	cx;
>  	unsigned short	dx;
>  	int		error;
> -	char 		*power_stat;
> -	char 		*bat_stat;
> +	char	*power_stat;
> +	char	*bat_stat;

Why not using same indention as for error?

-Robert

>  
>  #ifdef CONFIG_SMP
>  	/* 2002/08/01 - WT
> -- 
> 1.5.4.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com


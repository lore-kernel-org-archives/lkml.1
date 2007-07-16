Return-Path: <linux-kernel-owner+w=401wt.eu-S1763854AbXGPKF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763854AbXGPKF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 06:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754674AbXGPKFJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 06:05:09 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:18064 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386AbXGPKFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 06:05:07 -0400
X-IronPort-AV: i="4.16,541,1175486400"; 
   d="scan'208"; a="34962255:sNHT25401306"
Subject: Re: [PATCH 3/3] Blackfin On-Chip RTC driver update for supporting
	BF54x
From: Bryan Wu <bryan.wu@analog.com>
Reply-To: bryan.wu@analog.com
To: bryan.wu@analog.com
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mike Frysinger <michael.frysinger@analog.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1184439008.3140.25.camel@roc-laptop>
References: <1184439008.3140.25.camel@roc-laptop>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Analog Devices, Inc.
Date: Mon, 16 Jul 2007 18:11:31 +0800
Message-Id: <1184580691.11988.2.camel@roc-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
X-OriginalArrivalTime: 16 Jul 2007 10:05:04.0135 (UTC) FILETIME=[C79A6170:01C7C790]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a trivial patch, I will merge to my blackfin-git tree.

Thanks
- Bryan Wu

On Sun, 2007-07-15 at 02:50 +0800, Bryan Wu wrote:
> 
> Signed-off-by: Mike Frysinger <michael.frysinger@analog.com> 
> Signed-off-by: Bryan Wu <bryan.wu@analog.com> 
> --- 
>  drivers/rtc/rtc-bfin.c |    2 +- 
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/rtc/rtc-bfin.c b/drivers/rtc/rtc-bfin.c 
> index 260ead9..1aa709d 100644 
> --- a/drivers/rtc/rtc-bfin.c 
> +++ b/drivers/rtc/rtc-bfin.c 
> @@ -1,6 +1,6 @@ 
>  /* 
>   * Blackfin On-Chip Real Time Clock Driver 
> - *  Supports BF531/BF532/BF533/BF534/BF536/BF537 
> + *  Supports BF53[123]/BF53[467]/BF54[2489] 
>   * 
>   * Copyright 2004-2007 Analog Devices Inc. 
>   * 
> --  
> 1.5.2 
> - 
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in 
> the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 
> Please read the FAQ at  http://www.tux.org/lkml/
> 

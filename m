Return-Path: <linux-kernel-owner+w=401wt.eu-S1762826AbXGWSWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762826AbXGWSWQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 14:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755006AbXGWSWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 14:22:01 -0400
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:40753 "EHLO
	outbound6-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755010AbXGWSWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 14:22:00 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Message-ID: <46A4F1C2.4010704@am.sony.com>
Date: Mon, 23 Jul 2007 11:21:54 -0700
From: Geoff Levand <geoffrey.levand@am.sony.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Jesper Juhl <jesper.juhl@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev@ozlabs.org,
       cbe-oss-dev@ozlabs.org
Subject: Re: [PATCH][36/37] Clean up duplicate includes in sound/ppc/
References: <200707211704.07263.jesper.juhl@gmail.com>
In-Reply-To: <200707211704.07263.jesper.juhl@gmail.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2007 18:21:54.0679 (UTC) FILETIME=[58F6A870:01C7CD56]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Juhl wrote:
> Hi,
> 
> This patch cleans up duplicate includes in
> 	XXXX/
> 
> 
> Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> ---
> 
> diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
> index 1aa0b46..27b6189 100644
> --- a/sound/ppc/snd_ps3.c
> +++ b/sound/ppc/snd_ps3.c
> @@ -33,7 +33,6 @@
>  #include <linux/dmapool.h>
>  #include <linux/dma-mapping.h>
>  #include <asm/firmware.h>
> -#include <linux/io.h>
>  #include <asm/dma.h>
>  #include <asm/lv1call.h>
>  #include <asm/ps3.h>

Acked-by: Geoff Levand <geoffrey.levand@am.sony.com>


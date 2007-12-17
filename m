Return-Path: <linux-kernel-owner+w=401wt.eu-S936994AbXLQUI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936994AbXLQUI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 15:08:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762301AbXLQTmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:42:12 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:58255 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934282AbXLQTmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:42:10 -0500
Date: Mon, 17 Dec 2007 13:36:58 -0600
From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, paulus@au1.ibm.com, linuxppc-dev@ozlabs.org,
       Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
       Andrew Morton <akpm@linux-foundation.org>, anton@au1.ibm.com
Subject: Re: [PATCH] arch/powerpc/: Spelling fixes
Message-ID: <20071217133658.3973000c@zod.rchland.ibm.com>
In-Reply-To: <1197919875-5288-13-git-send-email-joe@perches.com>
References: <1197919875-5288-13-git-send-email-joe@perches.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2007 11:30:12 -0800
Joe Perches <joe@perches.com> wrote:

> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  arch/powerpc/boot/4xx.c                 |    2 +-
>  arch/powerpc/kernel/legacy_serial.c     |    2 +-
>  arch/powerpc/sysdev/bestcomm/bestcomm.h |    2 +-
>  arch/powerpc/sysdev/mmio_nvram.c        |    2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
> index ebf9e21..3d0e4f9 100644
> --- a/arch/powerpc/boot/4xx.c
> +++ b/arch/powerpc/boot/4xx.c
> @@ -122,7 +122,7 @@ void ibm4xx_denali_fixup_memsize(void)
>  	else
>  		dpath = 4; /* 32 bits */
> 
> -	/* get adress pins (rows) */
> +	/* get address pins (rows) */
>  	val = mfdcr_sdram0(DDR0_42);
> 
>  	row = DDR_GET_VAL(val, DDR_APIN, DDR_APIN_SHIFT);

Ack on this part.

josh

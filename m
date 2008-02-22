Return-Path: <linux-kernel-owner+w=401wt.eu-S1760662AbYBVVgS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760662AbYBVVgS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:36:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbYBVVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:36:06 -0500
Received: from rtr.ca ([76.10.145.34]:2497 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922AbYBVVgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:36:04 -0500
Message-ID: <47BF4043.8080802@rtr.ca>
Date: Fri, 22 Feb 2008 16:36:03 -0500
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide: remove stale comments from ide-dma.c
References: <200802222224.53642.bzolnier@gmail.com>
In-Reply-To: <200802222224.53642.bzolnier@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> - ide-dma.c is not a separate module
> 
> - ide-dma.c is not PCI specific anymore
> 
> - DMA is enabled by default nowadays
> 
> - link for Intel Zappa BIOS is dead
> 
> etc.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-dma.c |   48 ------------------------------------------------
>  1 file changed, 48 deletions(-)
> 
> Index: b/drivers/ide/ide-dma.c
> ===================================================================
> --- a/drivers/ide/ide-dma.c
> +++ b/drivers/ide/ide-dma.c
> @@ -11,49 +11,6 @@
>   */
>  
>  /*
> - * This module provides support for the bus-master IDE DMA functions
> - * of various PCI chipsets, including the Intel PIIX (i82371FB for
> - * the 430 FX chipset), the PIIX3 (i82371SB for the 430 HX/VX and 
> - * 440 chipsets), and the PIIX4 (i82371AB for the 430 TX chipset)
> - * ("PIIX" stands for "PCI ISA IDE Xcellerator").
> - *
> - * Pretty much the same code works for other IDE PCI bus-mastering chipsets.
> - *
> - * DMA is supported for all IDE devices (disk drives, cdroms, tapes, floppies).
..

Those top comments still look relevant, or at least as relevant
as the rest of the file (and subsystem) itself.  :)

Sigh.

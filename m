Return-Path: <linux-kernel-owner+w=401wt.eu-S940430AbXHMOJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940430AbXHMOJj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:09:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940191AbXHMLLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:11:12 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58060 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S944115AbXHMLLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:11:10 -0400
Date: Mon, 13 Aug 2007 12:18:07 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-omap-open-source@linux.omap.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [472/2many] MAINTAINERS - TI OMAP MMC INTERFACE DRIVER
Message-ID: <20070813121807.26014455@the-village.bc.nu>
In-Reply-To: <46bffc14.hGERPpPFcYe9DKoT%joe@perches.com>
References: <46bffc14.hGERPpPFcYe9DKoT%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:37:08 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index af16a17..7a7f837 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4478,7 +4478,7 @@ F:	drivers/misc/tifm*
>  F:	drivers/mmc/host/tifm_sd.c
>  
>  TI OMAP MMC INTERFACE DRIVER
> -P:	Carlos Aguiar, Anderson Briglia and Syed Khasim
> +P:	Carlos Aguiar - Anderson Briglia - Syed Khasim

NAK, Please stop sneaking other irrelevant changes into the patchset

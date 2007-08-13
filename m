Return-Path: <linux-kernel-owner+w=401wt.eu-S1031040AbXHMOAW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031040AbXHMOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:00:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940800AbXHMKrx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:47:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50942 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S940588AbXHMKrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:47:51 -0400
Date: Mon, 13 Aug 2007 11:54:38 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, shannon.nelson@intel.com,
       linux-kernel@vger.kernel.org, dan.j.williams@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [158/2many] MAINTAINERS - DMA GENERIC OFFLOAD ENGINE
 SUBSYSTEM
Message-ID: <20070813115438.5d7705f8@the-village.bc.nu>
In-Reply-To: <46bff992.LnPkEgfnfLCX18hX%joe@perches.com>
References: <46bff992.LnPkEgfnfLCX18hX%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:26:26 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 60bda8d..70e5070 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1544,6 +1544,9 @@ P:	Dan Williams
>  M:	dan.j.williams@intel.com
>  L:	linux-kernel@vger.kernel.org
>  S:	Supported
> +F:	drivers/dma/
> +F:	include/linux/dma*
> +F:	kernel/dma.c

NAK - kernel/dma.c is for old style host ISA DMA

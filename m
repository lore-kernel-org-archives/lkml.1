Return-Path: <linux-kernel-owner+w=401wt.eu-S1752562AbXHMN4e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbXHMN4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:56:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939585AbXHMKlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:41:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38728 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S939536AbXHMKlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:41:13 -0400
Date: Mon, 13 Aug 2007 11:47:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, sfr@canb.auug.org.au,
       linux-laptop@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [44/2many] MAINTAINERS - APM DRIVER
Message-ID: <20070813114730.107f1402@the-village.bc.nu>
In-Reply-To: <46bff8b6.XgYxpWqOSD9Itfw6%joe@perches.com>
References: <46bff8b6.XgYxpWqOSD9Itfw6%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:22:46 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 016f342..da9bc6d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -428,6 +428,9 @@ M:	sfr@canb.auug.org.au
>  L:	linux-laptop@vger.kernel.org
>  W:	http://www.canb.auug.org.au/~sfr/
>  S:	Supported
> +F:	arch/i386/boot/apm.c
> +F:	arch/i386/kernel/apm.c
> +F:	include/linux/apm_bios.h

NAK - boot/apm.c seems to be maintained by H Peter Anvin


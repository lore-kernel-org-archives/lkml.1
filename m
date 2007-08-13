Return-Path: <linux-kernel-owner+w=401wt.eu-S946103AbXHMOFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946103AbXHMOFU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943362AbXHMK7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:59:21 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47654 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S943502AbXHMK7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:59:19 -0400
Date: Mon, 13 Aug 2007 12:06:26 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [241/2many] MAINTAINERS - IDE/ATAPI CDROM DRIVER
Message-ID: <20070813120626.1f0447d9@the-village.bc.nu>
In-Reply-To: <46bffa41.8uNto66i1R9GDZK6%joe@perches.com>
References: <46bffa41.8uNto66i1R9GDZK6%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:29:21 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index d22e45a..b77decd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2285,6 +2285,8 @@ P:	Alan Cox
>  M:	alan@lxorguk.ukuu.org.uk
>  L:	linux-ide@vger.kernel.org
>  S:	Maintained
> +F:	Documentation/cdrom/ide-cd
> +F:	drivers/ide/ide-cd.*

Acked-by: Alan Cox <alan@redhat.com>

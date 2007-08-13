Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbXHMN6u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbXHMN6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:58:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940151AbXHMKpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:45:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50930 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935223AbXHMKpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:45:44 -0400
Date: Mon, 13 Aug 2007 11:51:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, mhw@wittsend.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] [132/2many] MAINTAINERS - COMPUTONE INTELLIPORT
 MULTIPORT CARD
Message-ID: <20070813115153.015bacb4@the-village.bc.nu>
In-Reply-To: <46bff95c.B/AyYjDHD4l0m/DL%joe@perches.com>
References: <46bff95c.B/AyYjDHD4l0m/DL%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:25:32 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4898b55..594881d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1277,6 +1277,9 @@ P:	Michael H. Warfield
>  M:	mhw@wittsend.com
>  W:	http://www.wittsend.com/computone.html
>  S:	Maintained
> +F:	Documentation/computone.txt
> +F:	drivers/char/ip2/
> +F:	drivers/serial/8250_pci.c

NAK. drivers/serial/8250_pci.c is RMK

Return-Path: <linux-kernel-owner+w=401wt.eu-S973372AbXHMN5Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S973372AbXHMN5Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:57:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939757AbXHMKlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:41:51 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:38730 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938693AbXHMKlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:41:49 -0400
Date: Mon, 13 Aug 2007 11:48:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, spyro@f2s.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [48/2many] MAINTAINERS - ARM MFM AND FLOPPY DRIVERS
Message-ID: <20070813114821.4c2877e7@the-village.bc.nu>
In-Reply-To: <46bff8be.Rm2ImM7V7+lJ/DhO%joe@perches.com>
References: <46bff8be.Rm2ImM7V7+lJ/DhO%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/MAINTAINERS b/MAINTAINERS
> index 435bafd..ca4a132 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -457,6 +457,9 @@ ARM MFM AND FLOPPY DRIVERS
>  P:	Ian Molton
>  M:	spyro@f2s.com
>  S:	Maintained
> +F:	arch/arm/lib/floppydma.S
> +F:	drivers/block/floppy.c

NAK drivers/block/floppy isn't ARM


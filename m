Return-Path: <linux-kernel-owner+w=401wt.eu-S945617AbXHMN7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S945617AbXHMN7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:59:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940200AbXHMKrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:47:40 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:50941 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S940681AbXHMKrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:47:37 -0400
Date: Mon, 13 Aug 2007 11:53:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Eng.Linux@digi.com
Subject: Re: [PATCH] [154/2many] MAINTAINERS - DIGI INTL. EPCA DRIVER
Message-ID: <20070813115344.04759b74@the-village.bc.nu>
In-Reply-To: <46bff988.qGtTTlNorD2He7J3%joe@perches.com>
References: <46bff988.qGtTTlNorD2He7J3%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:26:16 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 36a7d25..edebf01 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1482,7 +1482,7 @@ L:	linux-kernel@vger.kernel.org
>  S:	Maintained
>  
>  DIGI INTL. EPCA DRIVER
> -P:	Digi International, Inc
> +P:	Digi International Inc

The "," is correct and how they added themselves.

Please don't hide other types of change in a large changeset without
notice, thats not good

NAK

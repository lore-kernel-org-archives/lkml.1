Return-Path: <linux-kernel-owner+w=401wt.eu-S1031769AbXHMNys@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031769AbXHMNys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 09:54:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937439AbXHMKjx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 06:39:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:43220 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S938446AbXHMKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 06:39:51 -0400
Date: Mon, 13 Aug 2007 11:46:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: joe@perches.com
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org, len.brown@intel.com,
       akpm@linux-foundation.org
Subject: Re: [PATCH] [22/2many] MAINTAINERS - ACPI
Message-ID: <20070813114612.04f2986a@the-village.bc.nu>
In-Reply-To: <46bff88d.zVo0DUSTuvIvka+P%joe@perches.com>
References: <46bff88d.zVo0DUSTuvIvka+P%joe@perches.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007 23:22:05 -0700
joe@perches.com wrote:

> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 1162fb7..93a100b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -251,6 +251,9 @@ L:	linux-acpi@vger.kernel.org
>  W:	http://acpi.sourceforge.net/
>  T:	git kernel.org:/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git
>  S:	Supported
> +F:	drivers/acpi/
> +F:	drivers/ata/libata-acp*
> +F:	drivers/pnp/pnpacpi/

NAK - libata-acpi isthe libata team

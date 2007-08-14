Return-Path: <linux-kernel-owner+w=401wt.eu-S1753414AbXHNHP3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414AbXHNHP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:15:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbXHNHPM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:15:12 -0400
Received: from ananke.telenet-ops.be ([195.130.137.78]:43749 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbXHNHPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:15:09 -0400
Date: Tue, 14 Aug 2007 09:15:05 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: joe@perches.com
cc: Roman Zippel <zippel@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-m68k@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] [305/2many] MAINTAINERS - M68K ARCHITECTURE
In-Reply-To: <46bffac7.PW2ZV6M6KL1265zG%joe@perches.com>
Message-ID: <Pine.LNX.4.64.0708140914090.20699@anakin>
References: <46bffac7.PW2ZV6M6KL1265zG%joe@perches.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Aug 2007, joe@perches.com wrote:
> Add file pattern to MAINTAINER entry
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index e4ba367..b01052d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2930,6 +2930,8 @@ L:	linux-m68k@lists.linux-m68k.org
>  W:	http://www.linux-m68k.org/
>  W:	http://linux-m68k-cvs.ubb.ca/
>  S:	Maintained
> +F:	arch/m68k/
> +F:	include/asm-m68k/
>  
>  M68K ON APPLE MACINTOSH
>  P:	Joshua Thompson

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Return-Path: <linux-kernel-owner+w=401wt.eu-S934026AbXGLTw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934026AbXGLTw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbXGLTwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:52:22 -0400
Received: from asia.telenet-ops.be ([195.130.137.74]:47787 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755828AbXGLTwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:52:21 -0400
Date: Thu, 12 Jul 2007 21:52:01 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Rob Landley <rob@landley.net>
Cc: Li Yang-r58472 <LeoLi@freescale.com>, Gerrit Huizenga <gh@us.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Kunai, Takashi" <kunai@linux-foundation.jp>,
       holzheu@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, lf_kernel_messages@linux-foundation.org,
       mtk-manpages@gmx.net, jack@suse.cz, randy.dunlap@oracle.com,
       gregkh@suse.de, pavel@ucw.cz, tim.bird@am.sony.com, arjan@infradead.org,
       sam@ravnborg.org, jengelh@computergmbh.de, joe@perches.com,
       auke-jan.h.kok@intel.com, hansendc@us.ibm.com, davem@davemloft.net,
       Valdis.Kletnieks@vt.edu, kenistoj@us.ibm.com, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Chinese Language Maintainer
In-Reply-To: <200707121205.20959.rob@landley.net>
Message-ID: <Pine.LNX.4.64.0707122151130.9546@anakin>
References: <989B956029373F45A0B8AF0297081890F05F2F@zch01exm26.fsl.freescale.net>
 <200707121205.20959.rob@landley.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Rob Landley wrote:
> --- /dev/null	2007-04-23 11:59:00.000000000 -0400
> +++ linux-2.6/Documentation/language-maintainers.txt	2007-07-12 11:49:20.000000000 -0400
> @@ -0,0 +1,20 @@
> +The langauges in which the Linux kernel is developed are C and English.
       ^^^^^^^^^
       languages

> +(Note that Linus Torvalds' native language is Swedish, yet he chose
> +to hold technical discussions in English.)
> +
> +The job of a language maintainer is to provide a point of contact for
> +non-english speaking developers who wish to merge their patches into the
> +Linux kernel.  Each language needs a specific language maintainer, who
> +accepts non-english patch submissions on behalf of the Linux kernel.
           ^^^^^^^^^^^
	   non-English
> +
> +A language maintainer accepts patches to the Linux kernel, written in C, from
> +authors who do not also speak English.  The language maintainer translates the

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

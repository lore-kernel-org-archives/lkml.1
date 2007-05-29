Return-Path: <linux-kernel-owner+w=401wt.eu-S1759053AbXE2H4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053AbXE2H4i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 03:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752150AbXE2H43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 03:56:29 -0400
Received: from adicia.telenet-ops.be ([195.130.132.56]:32781 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXE2H43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 03:56:29 -0400
Date: Tue, 29 May 2007 09:56:26 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: stuff ready to be deleted?
In-Reply-To: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0705290953420.4790@anakin>
References: <Pine.LNX.4.64.0705281612560.15449@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007, Robert P. J. Day wrote:
>   i'm trying to keep track of kernel janitor projects that involve
> removing dead content from the tree:
> 
> http://fsdev.net/wiki/index.php?title=Kernel_Janitor%27s_Todo_List
> 
> currently, the list contains the items:

    [...]

>     * 11 Macintosh M68K support

It's not that because Mac/m68k went skipped 2.4.x that it should be removed...

>     * 12 Commodore A2232 serial support

M68k doesn't do SMP, so BROKEN_ON_SMP is IMHO not a good reason...


    [...]

> which of the above are legitimate candidates for removal?  which are
> already underway in someone's local tree?  anything else that can
> be added?  etc, etc.


Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

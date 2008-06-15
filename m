Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbYFOMAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbYFOMAi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 08:00:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757304AbYFOMAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 08:00:30 -0400
Received: from nelson.telenet-ops.be ([195.130.133.66]:54797 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757297AbYFOMA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 08:00:29 -0400
Date: Sun, 15 Jun 2008 14:00:24 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: adaplas@gmail.com, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] drivers/video/c2p.c: add MODULE_LICENSE
In-Reply-To: <20080609222202.GB1987@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0806151359520.5736@anakin>
References: <20080609222202.GB1987@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jun 2008, Adrian Bunk wrote:
> This patch adds the missing MODULE_LICENSE("GPL").
> 
> Reported-by: Adrian Bunk <bunk@kernel.org>
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Queued for 2.6.27:
    drivers/video/c2p.c: add MODULE_LICENSE                               
    export amiga_vblank                                                   
    export c2p                                                            
    m68k/amiga/: possible cleanups                                        
    m68k/atari/debug.c: possible cleanups                                 
    m68k/mac/: possible cleanups                                          
    m68k/q40/config.c: make functions static                              
    m68k/sun3/: possible cleanups              

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

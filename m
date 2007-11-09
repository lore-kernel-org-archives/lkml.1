Return-Path: <linux-kernel-owner+w=401wt.eu-S1762777AbXKIOYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762777AbXKIOYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 09:24:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754550AbXKIOYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 09:24:11 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:55617 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752529AbXKIOYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 09:24:10 -0500
Date: Fri, 9 Nov 2007 15:23:46 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: funaho@jurai.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kill drivers/nubus/nubus_syms.c
Message-ID: <20071109142346.GD26163@stusta.de>
References: <20071105170759.GZ12045@stusta.de> <Pine.LNX.4.64.0711060930430.13400@anakin>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0711060930430.13400@anakin>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2007 at 09:32:16AM +0100, Geert Uytterhoeven wrote:
> On Mon, 5 Nov 2007, Adrian Bunk wrote:
> > EXPORT_SYMBOL's belong to the actual code.
> 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
> if you add a #include <linux/module.h> to drivers/nubus/proc.c.
> 
> I fixed it myself and added your 7 patches to my queue.

Ups, thanks for spotting and fixing.

> Gr{oetje,eeting}s,
> 
> 						Geert

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed


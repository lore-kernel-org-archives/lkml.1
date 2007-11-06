Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbXKFIc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbXKFIc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 03:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754697AbXKFIcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 03:32:19 -0500
Received: from adicia.telenet-ops.be ([195.130.132.56]:44475 "EHLO
	adicia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754542AbXKFIcS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 03:32:18 -0500
Date: Tue, 6 Nov 2007 09:32:16 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: funaho@jurai.org, zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] kill drivers/nubus/nubus_syms.c
In-Reply-To: <20071105170759.GZ12045@stusta.de>
Message-ID: <Pine.LNX.4.64.0711060930430.13400@anakin>
References: <20071105170759.GZ12045@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2007, Adrian Bunk wrote:
> EXPORT_SYMBOL's belong to the actual code.

> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
if you add a #include <linux/module.h> to drivers/nubus/proc.c.

I fixed it myself and added your 7 patches to my queue.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

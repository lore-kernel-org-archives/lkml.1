Return-Path: <linux-kernel-owner+w=401wt.eu-S1765561AbYBZUwt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765561AbYBZUwt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:52:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761876AbYBZUwk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:52:40 -0500
Received: from nelson.telenet-ops.be ([195.130.133.66]:49326 "EHLO
	nelson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751267AbYBZUwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:52:39 -0500
Date: Tue, 26 Feb 2008 21:52:36 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] m68k: use KBUILD_DEFCONFIG
In-Reply-To: <20080226195500.GD4898@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802262152140.22486@anakin>
References: <20080226195500.GD4898@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Adrian Bunk wrote:
> The default defconfig should be one from arch/m68k/configs/
> 
> arch/m68k/defconfig was not exactly identical to amiga_defconfig but 
> also considering how long they have been without any update that doesn't 
> seem to have been on purpose.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

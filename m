Return-Path: <linux-kernel-owner+w=401wt.eu-S1755106AbYCaFzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106AbYCaFzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 01:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752118AbYCaFzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 01:55:07 -0400
Received: from wilson.telenet-ops.be ([195.130.132.42]:34470 "EHLO
	wilson.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbYCaFzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 01:55:06 -0400
Date: Mon, 31 Mar 2008 07:55:04 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <adrian.bunk@movial.fi>
cc: zippel@linux-m68k.org, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] m68k: use KBUILD_DEFCONFIG
In-Reply-To: <20080330224921.GZ28445@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0803310754260.6871@anakin>
References: <20080330224921.GZ28445@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Mar 2008, Adrian Bunk wrote:
> The default defconfig should be one from arch/m68k/configs/
> 
> arch/m68k/defconfig was not exactly identical to amiga_defconfig but 
> also considering how long they have been without any update that doesn't 
> seem to have been on purpose.
> 
> Signed-off-by: Adrian Bunk <adrian.bunk@movial.fi>
> Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

I'm working on the defconfigs and plan to update them after 2.6.25.
Your patch is also in my queue.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

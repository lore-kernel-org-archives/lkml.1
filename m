Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYEZOUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYEZOUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754873AbYEZOUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:20:47 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:34365 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677AbYEZOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:20:46 -0400
Date: Mon, 26 May 2008 16:20:43 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, Linux/m68k <linux-m68k@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 26
In-Reply-To: <20080526172222.b6979523.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0805261430020.4417@anakin>
References: <20080526172222.b6979523.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Stephen,

On Mon, 26 May 2008, Stephen Rothwell wrote:
> We are up to 81 trees (counting Linus' and 13 trees of patches pending for
> Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.
> 
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

Now multi_defconfig is in Linus' tree, do you mind enabling builds for
m68k multi_defconfig and sun3_defconfig using Linus' tree, too?

Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

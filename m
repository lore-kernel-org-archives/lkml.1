Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYFPGUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYFPGUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 02:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYFPGU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 02:20:29 -0400
Received: from edna.telenet-ops.be ([195.130.132.58]:52221 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbYFPGU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 02:20:28 -0400
Date: Mon, 16 Jun 2008 08:20:23 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
In-Reply-To: <20080615181100.79e48697.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0806160819080.5736@anakin>
References: <Pine.LNX.4.64.0712161148340.5869@anakin>
 <20071218030131.8b272833.akpm@linux-foundation.org> <Pine.LNX.4.64.0712182051050.24841@anakin>
 <20071218123119.54262974.akpm@linux-foundation.org> <Pine.LNX.4.64.0712231142190.24252@anakin>
 <Pine.LNX.4.64.0806151606320.5736@anakin> <20080615181100.79e48697.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jun 2008, Andrew Morton wrote:
> On Sun, 15 Jun 2008 16:07:45 +0200 (CEST) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > On Sun, 23 Dec 2007, Geert Uytterhoeven wrote:
> > > New version below. Tested on Amiga. Compile-tested on ia32 (i386_defconfig) and
> > > pp64 (ps3_defconfig).
> > 
> > Ping?
> 
> You appear to have a six month RTT ;)
> 
> If this was not a mistaken email and if you have something which needs
> to be in 2.6.26 then please send it to Linus directly - I'm hiding from
> you guys for a week.

`need' is a strong word. I prefer to have it receive some testing on
other platforms. I don't want to risk breaking something this late in
the 2.6.26 cycle...

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

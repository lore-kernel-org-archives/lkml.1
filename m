Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbYGUALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbYGUALq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2008 20:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754163AbYGUALf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jul 2008 20:11:35 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:38924 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757041AbYGUALe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2008 20:11:34 -0400
Date: Mon, 21 Jul 2008 02:11:25 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 17/29] m68k/atari/debug.c: possible cleanups
In-Reply-To: <alpine.DEB.1.00.0807202204550.3442@zirkon.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0807210202260.20940@anakin>
References: <20080717191607.955742542@mail.of.borg> <20080717191754.149215226@mail.of.borg>
 <alpine.DEB.1.00.0807202204550.3442@zirkon.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jul 2008, Michael Schmitz wrote:
> > - remove the following unused variables:
> >  - atari_SCC_init_done
> 
> That one I'll need to reintroduce for the SCC driver rewrite (which is still
> stuck in Geert's queue pending cleanups by me).

I already have a reintroducing patch in my queue,  So Linus can just
apply the removal patch for now.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

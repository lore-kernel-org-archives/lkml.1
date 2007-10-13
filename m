Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbXJMMiA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbXJMMiA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 08:38:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760382AbXJMMgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 08:36:09 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:58007 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760307AbXJMMgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 08:36:07 -0400
Message-Id: <20071013123123.085686856@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sat, 13 Oct 2007 14:31:23 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/8] m68k patches for 2.6.24
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are some m68k patches for 2.6.24:
  [1] m68k: Atari input drivers cleanup
  [2] m68k: Atari keyboard ACIA driver cleanup
  [3] m68k: ignore restart_syscall
  [4] m68k: Export cachectl.h
  [5] dm: emc_endio returns void
  [6] m68k: fix net drivers after recent get_stats updates
  [7] b43 wireless needs <linux/io.h>
  [8] ssb bus needs <linux/io.h>

Patches 1-4 are m68k support updates.
Patches 5-8 are fixes for regressions/failures introduced after 2.6.23.

Please apply, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


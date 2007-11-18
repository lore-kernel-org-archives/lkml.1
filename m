Return-Path: <linux-kernel-owner+w=401wt.eu-S1755965AbXKRKPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965AbXKRKPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:15:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751935AbXKRKPQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:15:16 -0500
Received: from agave.telenet-ops.be ([195.130.137.77]:43737 "EHLO
	agave.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbXKRKPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:15:14 -0500
Message-Id: <20071118101336.330321764@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:13:36 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [patch 00/13] m68k patches for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Andrew,

Here are some m68k patches for 2.6.25:
  [1] m68k: ARRAY_SIZE() cleanup
  [2] dio: ARRAY_SIZE() cleanup
  [3] m68k: Balance ioremap and iounmap in m68k/atari/hades-pci.c
  [4] nubus: kill drivers/nubus/nubus_syms.c
  [5] m68k: kill arch/m68k/mac/mac_ksyms.c
  [6] m68k: kill arch/m68k/hp300/ksyms.c
  [7] m68k: kill arch/m68k/amiga/amiga_ksyms.c
  [8] m68k: kill arch/m68k/atari/atari_ksyms.c
  [9] m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
  [10] mac68k: macii adb comment correction
  [11] mac68k: remove dead code
  [12] mac68k: add nubus card definitions and a typo fix
  [13] mac68k: remove dead MAC_ADBKEYCODES

Please queue for 2.6.25. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


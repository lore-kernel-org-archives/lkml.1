Return-Path: <linux-kernel-owner+w=401wt.eu-S1756898AbYA0MfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756898AbYA0MfU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:35:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYA0Me6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:34:58 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:60734 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYA0Me5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:34:57 -0500
Message-Id: <20080127123216.897698766@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 27 Jan 2008 13:32:16 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 00/14] M68k patches for 2.6.25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are the m68k patches I had queued up for 2.6.25:
  [1] m68k: Use cc-cross-prefix
  [2] m68k: ARRAY_SIZE() cleanup
  [3] dio: ARRAY_SIZE() cleanup
  [4] m68k: Balance ioremap and iounmap in m68k/atari/hades-pci.c
  [5] nubus: kill drivers/nubus/nubus_syms.c
  [6] m68k: kill arch/m68k/mac/mac_ksyms.c
  [7] m68k: kill arch/m68k/hp300/ksyms.c
  [8] m68k: kill arch/m68k/amiga/amiga_ksyms.c
  [9] m68k: kill arch/m68k/atari/atari_ksyms.c
  [10] m68k: kill arch/m68k/mvme16x/mvme16x_ksyms.c
  [11] mac68k: macii adb comment correction
  [12] mac68k: remove dead code
  [13] mac68k: add nubus card definitions and a typo fix
  [14] mac68k: remove dead MAC_ADBKEYCODES

Please apply, thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


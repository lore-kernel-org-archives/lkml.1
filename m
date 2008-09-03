Return-Path: <linux-kernel-owner+w=401wt.eu-S1754726AbYICHS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726AbYICHS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 03:18:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbYICHSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 03:18:12 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:53174 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbYICHSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 03:18:11 -0400
Message-Id: <20080903071542.615137611@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 03 Sep 2008 09:15:42 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/8] RFC: m68k patches for 2.6.28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the m68k patches I have queued for 2.6.28 that haven't been posted
for review yet:
  [1] [PATCH] m68k: Use new printk() extension %pS to print symbols
  [2] [PATCH] m68k: Reverse platform MMU logic so Sun 3 is last
  [3] [PATCH] m68k: Disable Amiga serial console support if modular
  [4] [PATCH] m68k: Modular Amiga keyboard needs key_maps
  [5] [PATCH] m68k: Remove unused atari_kbd_translate()
  [6] [PATCH] m68k: Define rtc_lock on Atari
  [7] [PATCH] m68k: Add missing dma_sync_single_range_for_{cpu,device}()
  [8] [PATCH] m68k: <asm/pci.h> needs <asm-generic/pci-dma-compat.h>

My full patch queue is at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.6/

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


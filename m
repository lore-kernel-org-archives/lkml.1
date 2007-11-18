Return-Path: <linux-kernel-owner+w=401wt.eu-S1753492AbXKRKM4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbXKRKM4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 05:12:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbXKRKMo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 05:12:44 -0500
Received: from asia.telenet-ops.be ([195.130.137.74]:57398 "EHLO
	asia.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXKRKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 05:12:43 -0500
Message-Id: <20071118101002.730422886@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Sun, 18 Nov 2007 11:10:02 +0100
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [patch 0/3] m68k patches for 2.6.24
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus, Andrew,

Here are 3 m68k patches for 2.6.24:
  [1] m68k: export atari_keyb_init
  [2] Amiga zorro bus: Add missing zorro_device_remove()
  [3] mac68k: mailing list addresss

Please apply. Thx!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


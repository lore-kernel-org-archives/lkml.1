Return-Path: <linux-kernel-owner+w=401wt.eu-S1755466AbYIJUQU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbYIJUQU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:16:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752359AbYIJUQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:16:01 -0400
Received: from monty.telenet-ops.be ([195.130.132.56]:39445 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbYIJUQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:16:00 -0400
Message-Id: <20080910201517.233690597@mail.of.borg>
User-Agent: quilt/0.46-1
Date: Wed, 10 Sep 2008 22:15:17 +0200
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] m68k patches for 2.6.27
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

Here are two more patches for m68k for 2.6.27:
  [1] [PATCH] VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
  [2] [PATCH] m68k: Update defconfigs for 2.6.27-rc6

The first one fixes a regression in m68k allmodconfig.
The second one is the classical defconfig update after all Kconfig changes have
settled.

Please apply. Also please note that Andrew no longer tracks m68k patches,
as the m68k tree is in linux-next.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds


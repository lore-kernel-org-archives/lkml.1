Return-Path: <linux-kernel-owner+w=401wt.eu-S1752983AbYLBUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbYLBUXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:23:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYLBUW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:22:58 -0500
Received: from monty.telenet-ops.be ([195.130.132.56]:40630 "EHLO
	monty.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYLBUW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:22:57 -0500
Date: Tue, 2 Dec 2008 21:22:54 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [git] m68k
Message-ID: <Pine.LNX.4.64.0812022117160.24347@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Linus,

[ First pull request, let's hope I got everything right... ]

Please pull from

    git://git.kernel.org:/pub/scm/linux/kernel/git/geert/linux-m68k.git for-linus

to receive the following m68k-related updates for 2.6.28:

Finn Thain (1):
      macfb: Do not overflow fb_fix_screeninfo.id

Geert Uytterhoeven (1):
      m68k: Update defconfigs for 2.6.28-rc7

 arch/m68k/configs/amiga_defconfig    |  126 +++++++++++++++++++--------------
 arch/m68k/configs/apollo_defconfig   |  115 +++++++++++++++++-------------
 arch/m68k/configs/atari_defconfig    |  130 +++++++++++++++++++---------------
 arch/m68k/configs/bvme6000_defconfig |  112 +++++++++++++++++-------------
 arch/m68k/configs/hp300_defconfig    |  115 +++++++++++++++++-------------
 arch/m68k/configs/mac_defconfig      |  125 ++++++++++++++++++--------------
 arch/m68k/configs/multi_defconfig    |  129 +++++++++++++++++++---------------
 arch/m68k/configs/mvme147_defconfig  |  112 +++++++++++++++++-------------
 arch/m68k/configs/mvme16x_defconfig  |  112 +++++++++++++++++-------------
 arch/m68k/configs/q40_defconfig      |  125 +++++++++++++++++++--------------
 arch/m68k/configs/sun3_defconfig     |  124 +++++++++++++++++++-------------
 arch/m68k/configs/sun3x_defconfig    |  115 +++++++++++++++++-------------
 drivers/video/macfb.c                |   74 +++++++++----------
 13 files changed, 863 insertions(+), 651 deletions(-)

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

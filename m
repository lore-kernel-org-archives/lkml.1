Return-Path: <linux-kernel-owner+w=401wt.eu-S1754412AbZCAJVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412AbZCAJVr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 04:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbZCAJVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 04:21:22 -0500
Received: from georges.telenet-ops.be ([195.130.137.68]:35980 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672AbZCAJVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 04:21:19 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] m68k patches for 2.6.30
Date: Sun,  1 Mar 2009 10:21:09 +0100
Message-Id: <1235899275-23630-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.6.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are the m68k patches I have queued up for 2.6.30:
    [1/6] m68k: Add install target
    [2/6] m68k: mac - Add a new entry in mac_model to identify the floppy
                controller type.
    [3/6] m68k: mac - Add SWIM floppy support
    [4/6] MAINTAINERS: Replace dead link to m68k CVS repository by link to new
                       git repository
    [5/6] m68k: section mismatch fixes: DMAsound for Atari
    [6/6] m68k: section mismatch fixes: Atari SCSI

They're also available on my for-2.6.30 branch (which may be rebased):

    http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git;a=shortlog;h=for-2.6.30

If anything is missing, please let me know.

Thanks for reviewing!

Gr{oetje,eeting}s,

                                                Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                                            -- Linus Torvalds

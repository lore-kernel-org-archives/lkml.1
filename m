Return-Path: <linux-kernel-owner+w=401wt.eu-S1754623AbYLNQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbYLNQbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 11:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753363AbYLNQbL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 11:31:11 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:46486 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753254AbYLNQbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 11:31:10 -0500
Date: Sun, 14 Dec 2008 17:31:08 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: make headers_install: .install and ..install.cmd
Message-ID: <Pine.LNX.4.64.0812141728370.5714@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Sam,

When I use `make ARCH=m68k INSTALL_HDR_PATH=/tmp/headers headers_install',
I get lots of `.install' and `..install.cmd' files in /tmp/headers and its
subdirectories.

I'm building the kernel in a separate output directory and run my make command
from there.

Is this intentional?

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

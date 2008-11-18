Return-Path: <linux-kernel-owner+w=401wt.eu-S1753829AbYKRUtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829AbYKRUtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 15:49:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbYKRUtH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 15:49:07 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:36795 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200AbYKRUtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 15:49:06 -0500
Date: Tue, 18 Nov 2008 21:49:01 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux/m68k <linux-m68k@vger.kernel.org>
cc: Ralf Baechle <ralf@linux-mips.org>, David Woodhouse <dwmw2@infradead.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: linux-m68k.git
Message-ID: <Pine.LNX.4.64.0811182136060.27671@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Finally) I created an experimental git tree for Linux/m68k:
http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git

It contains more or less all patches I had in my quilt series at
http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.6/
A notable exception is m68k-PRIVATE-m68k-changes.diff, which hardcoded ARCH to
m68k.

As suggested by David Woodhouse, I grouped the commits by topic. But unlike
David's suggestion, I used topic branches, not topic repositories. Oh well,
we'll see...

I also created for-next and for-linus branches. Do they look OK?

If I did something wrong, please let me know.
This is still experimental stuff, which may be rebased if needed.

In addition, one day I may pull from Ralf's repository that reflects the state
of Linux/m68k CVS a few commits before our server died...

Thanks for all your (past and future) help, suggestions, tips and tricks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

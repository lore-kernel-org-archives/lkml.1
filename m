Return-Path: <linux-kernel-owner+w=401wt.eu-S1752564AbXBDVcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbXBDVcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 16:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXBDVcQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 16:32:16 -0500
Received: from gate.crashing.org ([63.228.1.57]:44463 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbXBDVcP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 16:32:15 -0500
Subject: Re: [Linux-fbdev-devel] radeonfb: Can't use the dvi port
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-fbdev-devel@lists.sourceforge.net
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20070204161521.GA9623@frodo.home.lxtec.de>
References: <20070204161521.GA9623@frodo.home.lxtec.de>
Content-Type: text/plain
Date: Mon, 05 Feb 2007 08:32:13 +1100
Message-Id: <1170624733.2620.41.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> I`ve compiled raeonfb debug in the kernel:
> Dec 26 14:52:05 frodo kernel: hStart = 1664, hEnd = 1856, hTotal = 2160
> Dec 26 14:52:05 frodo kernel: vStart = 1201, vEnd = 1204, vTotal = 1250
> Dec 26 14:52:05 frodo kernel: h_total_disp = 0xc7010d hsync_strt_wid = 0x18067a
> Dec 26 14:52:05 frodo kernel: v_total_disp = 0x4af04e1 vsync_strt_wid = 0x304b0
> Dec 26 14:52:05 frodo kernel: pixclock = 6172
> Dec 26 14:52:05 frodo kernel: freq = 16202
> Dec 26 14:52:05 frodo kernel: freq = 16202, PLL min = 20000, PLL max = 40000
> Dec 26 14:52:05 frodo kernel: ref_div = 12, ref_clk = 2700, output_freq = 32404
> Dec 26 14:52:05 frodo kernel: ref_div = 12, ref_clk = 2700, output_freq = 32404
> Dec 26 14:52:05 frodo kernel: post div = 0x1
> Dec 26 14:52:05 frodo kernel: fb_div = 0x90
> Dec 26 14:52:05 frodo kernel: ppll_div_3 = 0x10090
> 
> My card:
> 01:00.0 VGA compatible controller: ATI Technologies Inc Radeon RV250 If [Radeon 9000] (rev 01)
> 
> Switching to the analog port works well.

Can I have the -full- dmesg log ?

Ben.



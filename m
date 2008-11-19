Return-Path: <linux-kernel-owner+w=401wt.eu-S1753184AbYKSIoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbYKSIoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 03:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYKSIoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 03:44:10 -0500
Received: from winston.telenet-ops.be ([195.130.137.75]:52028 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752016AbYKSIoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 03:44:09 -0500
Date: Wed, 19 Nov 2008 09:44:03 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org
Subject: Re: linux-m68k.git
In-Reply-To: <20081119081951.a1a33403.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0811190942490.27671@anakin>
References: <Pine.LNX.4.64.0811182136060.27671@anakin>
 <20081119081951.a1a33403.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Stephen,

On Wed, 19 Nov 2008, Stephen Rothwell wrote:
> On Tue, 18 Nov 2008 21:49:01 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > (Finally) I created an experimental git tree for Linux/m68k:
> > http://git.kernel.org/?p=linux/kernel/git/geert/linux-m68k.git
> > 
> > It contains more or less all patches I had in my quilt series at
> > http://www.kernel.org/pub/linux/kernel/people/geert/linux-m68k-patches-2.6/
> > A notable exception is m68k-PRIVATE-m68k-changes.diff, which hardcoded ARCH to
> > m68k.
> > 
> > I also created for-next and for-linus branches. Do they look OK?
> 
> They look good.  I have added the for-linus branch as my m68k-current

What's the purpose of your m68k-current tree? There should not be anything
in m68k#for-linus that's not in m68k#for-next.

> tree and changed my m68k tree over to the for-next branch.

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

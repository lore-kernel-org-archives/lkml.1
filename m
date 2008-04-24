Return-Path: <linux-kernel-owner+w=401wt.eu-S1752144AbYDXHqQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbYDXHqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 03:46:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751132AbYDXHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 03:45:59 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:54626 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750860AbYDXHp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 03:45:58 -0400
Date: Thu, 24 Apr 2008 09:45:57 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for April 24
In-Reply-To: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0804240942300.10239@vixen.sonytel.be>
References: <20080424173626.bcd088e7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi Stephen,

On Thu, 24 Apr 2008, Stephen Rothwell wrote:
> Status of my local build tests will be at
> http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
> advice about cross compilers/configs that work, we are always open to add
> more builds.

For m68k, I've added multi_defconfig, to build a kernel for all supported m68k
platforms, excluding Sun 3 (Sun 3 kernels are incompatible with all other m68k
platforms).

Hence if you would build multi_defconfig and sun3_defconfig, you cover all of
our platforms and drivers.

Alternatively, you can just build all defconfigs, but that's more work ;-)

Thx for linux-next!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

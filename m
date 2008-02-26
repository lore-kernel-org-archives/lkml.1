Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbYBZHzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbYBZHzY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 02:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756060AbYBZHzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 02:55:11 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:60930 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753362AbYBZHzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 02:55:09 -0500
Date: Tue, 26 Feb 2008 08:55:07 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: linux-next: Tree for Feb 24
In-Reply-To: <20080226104956.7d4d9402.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0802260853080.5158@anakin>
References: <20080224162309.3e67dd22.sfr@canb.auug.org.au>
 <Pine.LNX.4.64.0802252252070.5158@anakin> <20080226104956.7d4d9402.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Stephen Rothwell wrote:
> On Mon, 25 Feb 2008 22:56:04 +0100 (CET) Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> >
> > Can you please add
> > http://linux-m68k-cvs.ubb.ca/~geert/linux-m68k-patches-2.6/series?
> > So far there's only one patch in between NEXT_PATCHES_{START,END} yet,
> > though.
> 
> Added, thanks.
> 
> > Ah, I see the m68k cross-compiler is still missing? ;-)
> 
> Please look again :-)  Are there any particular configs we should build?

Great!

I really should update the defconfigs, and add a `defconfig_all' which
builds a kernel for all platforms (except Sun-3).

For now defconfig is OK, I think.

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

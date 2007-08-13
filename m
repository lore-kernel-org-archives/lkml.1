Return-Path: <linux-kernel-owner+w=401wt.eu-S935122AbXHMPb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935122AbXHMPb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S973136AbXHMNaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:30:18 -0400
Received: from loopy.telegraphics.com.au ([202.45.126.152]:48129 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S973127AbXHMNaP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:30:15 -0400
X-Greylist: delayed 1241 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Aug 2007 09:30:14 EDT
Date: Mon, 13 Aug 2007 23:09:30 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       debian-68k@lists.debian.org
Subject: Re: [patch 10/10] m68k/mac: Make mac_hid_mouse_emulate_buttons()
 declaration visible
In-Reply-To: <Pine.LNX.4.58.0708131432560.32732@om.biophys.uni-duesseldorf.de>
Message-ID: <Pine.LNX.4.64.0708132253530.21364@loopy.telegraphics.com.au>
References: <20070812094050.522858761@mail.of.borg> <20070812094119.910815432@mail.of.borg>
 <Pine.LNX.4.58.0708131432560.32732@om.biophys.uni-duesseldorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 13 Aug 2007, Michael Schmitz wrote:

> > From: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > m68k/mac: Make mac_hid_mouse_emulate_buttons() declaration visible
> 
> With buttons emulation being available via uinput event devices, do we 
> still need the kernel mouse button emulation? At least on powerpc, it 
> was declared deprecated long ago ...
>
> Anyone using mouseemu on m68k Mac?

Yes, and on powermac too. It provides the paste key for gpm and I'm quite 
fond of it. But if there's a better alternative, I'll happily try it 
instead.

-f

> 
> 	Michael
> -
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

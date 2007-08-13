Return-Path: <linux-kernel-owner+w=401wt.eu-S946512AbXHMPgs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946512AbXHMPgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:36:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030924AbXHMNgF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:36:05 -0400
Received: from opal.biophys.uni-duesseldorf.de ([134.99.176.7]:36956 "EHLO
	opal.biophys.uni-duesseldorf.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S973114AbXHMNgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:36:01 -0400
Date: Mon, 13 Aug 2007 15:35:04 +0200 (CEST)
From: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>
To: Finn Thain <fthain@telegraphics.com.au>
cc: Michael Schmitz <schmitz@opal.biophys.uni-duesseldorf.de>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-m68k@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       linux-input@atrey.karlin.mff.cuni.cz, linuxppc-dev@ozlabs.org,
       debian-68k@lists.debian.org
Subject: Re: [patch 10/10] m68k/mac: Make mac_hid_mouse_emulate_buttons()
 declaration visible
In-Reply-To: <Pine.LNX.4.64.0708132253530.21364@loopy.telegraphics.com.au>
Message-ID: <Pine.LNX.4.58.0708131531440.585@om.biophys.uni-duesseldorf.de>
References: <20070812094050.522858761@mail.of.borg> <20070812094119.910815432@mail.of.borg>
 <Pine.LNX.4.58.0708131432560.32732@om.biophys.uni-duesseldorf.de>
 <Pine.LNX.4.64.0708132253530.21364@loopy.telegraphics.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Anyone using mouseemu on m68k Mac?
>
> Yes, and on powermac too. It provides the paste key for gpm and I'm quite
> fond of it. But if there's a better alternative, I'll happily try it
> instead.

Too much overhead on m68k? On powermac it never gave me trouble, but I was
surprised to hear people use it on m68k.

If it works OK, we can really drop the kernel support.

	Michael

Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbXL2WWq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbXL2WWq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 17:22:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752072AbXL2WWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 17:22:34 -0500
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:36985 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbXL2WWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 17:22:33 -0500
Date: Sat, 29 Dec 2007 23:21:41 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org
Subject: Re: Top 9 kernel oopses/warnings for the week of December 29th, 2007
In-Reply-To: <alpine.LFD.0.9999.0712291147400.2778@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0712292257430.17197@anakin>
References: <477630CF.5070609@linux.intel.com>
 <alpine.LFD.0.9999.0712291116190.2778@woody.linux-foundation.org>
 <4776A13C.1080405@linux.intel.com> <alpine.LFD.0.9999.0712291147400.2778@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 Dec 2007, Linus Torvalds wrote:
> On Sat, 29 Dec 2007, Arjan van de Ven wrote:
> > hmmm.. the copy in my Sent folder looks fine, as does the one in the lkml
> > archive:
> > http://lkml.org/lkml/2007/12/29/41
> > 
> > This is distinctly weird.
> 
> Ahh, it seems to be a alpine bug. Probably brought on by alpine trying to 
> highlight the web addresses.
> 
> It doesn't always happen - between Rank 3 and Rank 4, you have an empty 
> line, and alpine reacted correctly to that one, but the "empty" line 
> between Rank 1 and Rank 2 actually contained a single TAB, and that 
> apparently made alpine really confused.
> 
> So never mind. I'll make a bug-report on alpine, it wasn't a bug in your 
> email.

The bug is also present in the original branch, called pine 4.64 ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Return-Path: <linux-kernel-owner+w=401wt.eu-S1752770AbXDMILP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752770AbXDMILP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 04:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbXDMILO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 04:11:14 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:40840 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbXDMILM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 04:11:12 -0400
Date: Fri, 13 Apr 2007 10:09:47 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Lang <david.lang@digitalinsight.com>
Cc: Gerhard Mack <gmack@innerfire.net>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org, Benny Amorsen <benny+usenet@amorsen.dk>
Subject: Re: [PATCH] Stop pmac_zilog from abusing 8250's device numbers.
In-Reply-To: <Pine.LNX.4.63.0704121917260.29621@qynat.qvtvafvgr.pbz>
Message-ID: <Pine.LNX.4.64.0704131009190.16292@anakin>
References: <1175644642.10567.31.camel@shinybook.infradead.org><200704032210
 02.GA13210@cynthia.pants.nu> <1175648051.10567.61.camel@shinybook.infradead.org><20070403.181645.6815945
 8.davem@davemloft.net> <20070404022828.5c9b97f3@the-village.bc.nu><Pine.LNX.4.64.0704032307001.780
 2@mtl.rackplans.net> <m3tzvm6fgw.fsf@ursa.amorsen.dk><adabqhtip2n.fsf@cisco.com>
 <Pine.LNX.4.64.0704122243280.9866@mtl.rackplans.net>
 <Pine.LNX.4.63.0704121917260.29621@qynat.qvtvafvgr.pbz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2007, David Lang wrote:
> On Thu, 12 Apr 2007, Gerhard Mack wrote:
> > Sometimes it's not the speed it's the cost.. The best I've ever done is
> > 5.5 interfaces per u/ Although with a better motherboard and case it might
> > have been different.
> 
> I have a bunch of servers from rackable, dual core cpu, 2G ram 2xgigE on the 
> motherboard (1x100M on motherboard), 4x Intel E1000 quad port cards, 120G SATA 
> drive, DVD burner, floppy
> 
> 3u, 18 gig ports, just under $5k

I don't think we're still talking about _serial_ ports?

Gr{oetje,eeting}s,

						Geert

P.S. Yes, Ethernet is serial ;-)
--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

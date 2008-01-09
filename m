Return-Path: <linux-kernel-owner+w=401wt.eu-S1753487AbYAIKkR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487AbYAIKkR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:40:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYAIKkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:40:05 -0500
Received: from edna.telenet-ops.be ([195.130.132.58]:37041 "EHLO
	edna.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751271AbYAIKkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:40:04 -0500
Date: Wed, 9 Jan 2008 09:29:41 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Valdis.Kletnieks@vt.edu
cc: Thanasis <thanasis@asyr.hopto.org>, linux-kernel@vger.kernel.org
Subject: Re: NIC as RS232
In-Reply-To: <9263.1199852504@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.64.0801090926590.1377@anakin>
References: <47831CC3.9080604@asyr.hopto.org> <9263.1199852504@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2008, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 08 Jan 2008 08:48:35 +0200, Thanasis said:
> > Is there a kernel driver that would make a NIC's port work as a RS232
> > port, using the serial cables that are RJ45 on one side and DB9 or DB25
> > on the other? Maybe null modem cables of that type ? Or for example
> > those used by cisco as console port cables?
> > 
> > (or may be I'm dreaming ;-)
> 
> What I *have* seen are connectors that go from DB9/25 to RJ11, not RJ45.
> Basically, using the RJ11 to terminate a 4-conductor cable wired up for
> serial use.  It's often hard to tell an 11 from a 45 unless you look at
> it *real* close....

We have plenty of DB9-to-RJ45 at work. Very useful when abusing the
Ethernet cabling in the wall for serial connections (also used for
phone).

Maybe surprisingly to you, I haven't seen the RJ11 variant ;-)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

Return-Path: <linux-kernel-owner+w=401wt.eu-S1755937AbYGVXtw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937AbYGVXtw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 19:49:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753629AbYGVXtn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 19:49:43 -0400
Received: from harold.telenet-ops.be ([195.130.133.65]:54879 "EHLO
	harold.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbYGVXtm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 19:49:42 -0400
Date: Wed, 23 Jul 2008 01:49:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: circumvention and ignorance (was: Re: linux-next: Tree
 for July 22)
In-Reply-To: <20080722184059.a58c79d7.sfr@canb.auug.org.au>
Message-ID: <Pine.LNX.4.64.0807230140000.28765@anakin>
References: <20080722184059.a58c79d7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

Looking at today's http://kisskb.ellerman.id.au/kisskb/matrix/, there's
plenty of red, and not only in the linux-next division :-(

On Tue, 22 Jul 2008, Stephen Rothwell wrote:
> We are up to 105 trees (counting Linus' and 14 trees of patches pending for
> Linus' tree), more are welcome (even if they are currently empty).
> Thanks to those who have contributed, and to those who haven't, please do.

We still see regular merging of trivially breaking patches that
apparently never have been in linux-next...

> The ttydev tree was partially merged upstream and gained so many
> conflicts that I have temporarily dropped it.

Worse, we're seeing things getting merged that have been known-broken in
several linux-next incarnations during the last few weeks...

Now we have such a great thing like linux-next (thanks, Stephen! You
saved my day a lot lately), perhaps we should start making full use of
it?

Thanks!

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds

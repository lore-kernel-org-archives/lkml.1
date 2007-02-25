Return-Path: <linux-kernel-owner+w=401wt.eu-S964869AbXBYMsm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964869AbXBYMsm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 07:48:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964868AbXBYMsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 07:48:42 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:35128 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S964869AbXBYMsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 07:48:41 -0500
Date: Sun, 25 Feb 2007 13:52:08 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: "Michael K. Edwards" <medwards.linux@gmail.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, davids@webmaster.com,
       "v j" <vj.linux@gmail.com>, trent.waddington@gmail.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       "Neil Brown" <neilb@suse.de>
Subject: Re: GPL vs non-GPL device drivers
Message-ID: <20070225135208.6e2eab9c@lxorguk.ukuu.org.uk>
In-Reply-To: <f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
References: <3d57814d0702191458l1021caeyaefd7775398c5f2a@mail.gmail.com>
	<MDEHLPKNGKAHNMBLJOLKIEFNBLAC.davids@webmaster.com>
	<f2b55d220702211408r7954d5dar2c59e1e679316811@mail.gmail.com>
	<20070225104211.GB2045@elf.ucw.cz>
	<f2b55d220702250354j29583e5ak1397d28ef7028783@mail.gmail.com>
X-Mailer: Claws Mail 2.7.2 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> of other places too.  Especially when the graphics chip maker explains
> that keeping their driver source code closed isn't really an attempt
> to hide their knowledge under a bushel basket.  It's a defensive
> measure against having their retail margins destroyed by nitwits who
> take out all the busy-wait loops and recompile with -O9 to get another
> tenth of a frame per second, and then pretend ignorance when
> attempting to return their slagged GPU at Fry's.

Wrong as usual...

The Nvidia driver and ATI drivers aren't full of magical delay loops and
if there was a way to fry those cards easily in hardware the virus folks
would already be doing it. The reverse engineering teams know what is in
the existing code thank you. Creating new open source drivers from it is
however hard because of all the corner cases.

You will instead find that both vendors stopping providing Linux related
source code at about the point they got Xbox related contracts. A matter
which has been pointed out to various competition and legal authorities
and for now where it seems to lie.

Fortunately at the moment there is a simple cure - buy Intel hardware.
That also has the advantage that you are more likely to get help because
some of us only look at AMD processor related problems as part of
official work duties nowdays, and plan to do so until AMD (as owner
of ATI) behave.

Alan

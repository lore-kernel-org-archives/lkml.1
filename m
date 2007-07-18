Return-Path: <linux-kernel-owner+w=401wt.eu-S935695AbXGRAKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935695AbXGRAKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 20:10:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755469AbXGRAJw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 20:09:52 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:39467 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759547AbXGRAJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 20:09:52 -0400
Date: Wed, 18 Jul 2007 01:16:15 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Shawn Bohrer <shawn.bohrer@gmail.com>
Cc: Rene Herman <rene.herman@gmail.com>, Ray Lee <ray-lk@madrabbit.org>,
       Bodo Eggert <7eggert@gmx.de>, Matt Mackall <mpm@selenic.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Message-ID: <20070718011615.7550f583@the-village.bc.nu>
In-Reply-To: <20070717161454.GB21538@mediacenter.austin.rr.com>
References: <E1IA7j1-0000j9-I3@be1.lrz>
	<469A5D7C.5010904@gmail.com>
	<Pine.LNX.4.58.0707161523500.25779@be1.lrz>
	<469BF104.1040703@gmail.com>
	<2c0942db0707161537o2852a308s26e79235e897e282@mail.gmail.com>
	<469BF768.6040200@gmail.com>
	<2c0942db0707161613lff9c07bpcf002b9139163a86@mail.gmail.com>
	<469BFDA7.1040204@gmail.com>
	<2c0942db0707161640h3c3afd7avecd7b3c61c4e7df1@mail.gmail.com>
	<469C1409.9010305@gmail.com>
	<20070717161454.GB21538@mediacenter.austin.rr.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> I can't speak for Fedora, but RHEL disables XFS in their kernel likely
> because it is known to cause problems with 4K stacks.

-was- - the SGI folks submitted patches to deal with some gcc problems
with stack usage.

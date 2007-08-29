Return-Path: <linux-kernel-owner+w=401wt.eu-S1758196AbXH2SVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758196AbXH2SVY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 14:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbXH2SVN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 14:21:13 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:41002 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750734AbXH2SVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 14:21:11 -0400
Date: Wed, 29 Aug 2007 19:28:58 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Jon Smirl" <jonsmirl@gmail.com>
Cc: "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Jiri Slaby" <jirislaby@gmail.com>, linville@tuxdriver.com,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 4/5] Net: ath5k, license is GPLv2
Message-ID: <20070829192858.75aa6542@the-village.bc.nu>
In-Reply-To: <9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>
References: <2713029743177393055@pripojeni.net>
	<7515194658758617@pripojeni.net>
	<20070828171155.GC29343@infradead.org>
	<3208.1188408545@turing-police.cc.vt.edu>
	<9e4733910708291101i3783a8b1l38f0d5cfb0c2863d@mail.gmail.com>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > to remove the BSD/other license.   Jiri can release *his* code as GPLv2
> > only, but I suspect the files as a whole really should be dual BSD/GPLv2,
> > due to the numerous other stakeholders in those files.
> 
> This mess has been occurring in the kernel for years. The DRM graphics
> drivers are used in both BSD and Linux. It is quite easy to contribute
> something to this code via LKML and think you are doing it under the
> GPL. Doesn't a patch against the kernel have to be GPL? When these
> patches get pulled back into BSD and distributed with it, did BSD get
> infected with the GPL? AFAIK this has never been legally sorted out.

I'm not aware anyone has felt it needed "sorting out". Its not exactly
complicated.

	BSD non advertising is compatible with GPL

The GPL says:
	"when you distribute the same sections as part of a whole which
	is a work based on the Program, the distribution of the whole
	must be on the terms of this License, "

The BSD license doesn't conflict with that

The GPL (and copyright law also say)

"If identifiable sections of that work are not derived from the Program,
and can be reasonably considered independent and separate works in
themselves, then this License, and its terms, do not apply to ..."

All a bit irrelevant anyway as Ath5K code (not the .h file) say:

 * Alternatively, this software may be distributed under the terms of the
 * GNU General Public License ("GPL") version 2 as published by the Free
 * Software Foundation.

So Jiri is choosing to distribute it under the GPL, and with his changes
GPL only.

So whats the problem ?


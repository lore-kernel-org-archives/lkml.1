Return-Path: <linux-kernel-owner+w=401wt.eu-S1765779AbXHDVly@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765779AbXHDVly (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 17:41:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762862AbXHDVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 17:41:47 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:49435 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762240AbXHDVlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 17:41:47 -0400
Date: Sat, 4 Aug 2007 22:48:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ingo Molnar <mingo@elte.hu>
Cc: J??rn Engel <joern@logfs.org>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-mm@kvack.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       miklos@szeredi.hu, akpm@linux-foundation.org, neilb@suse.de,
       dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com, nikita@clusterfs.com,
       trond.myklebust@fys.uio.no, yingchao.zhou@gmail.com,
       richard@rsk.demon.co.uk, david@lang.hm
Subject: Re: [PATCH 00/23] per device dirty throttling -v8
Message-ID: <20070804224834.5187f9b7@the-village.bc.nu>
In-Reply-To: <20070804202830.GA4538@elte.hu>
References: <20070804063217.GA25069@elte.hu>
	<20070804070737.GA940@elte.hu>
	<20070804103347.GA1956@elte.hu>
	<alpine.LFD.0.999.0708040915360.5037@woody.linux-foundation.org>
	<20070804163733.GA31001@elte.hu>
	<alpine.LFD.0.999.0708041030040.5037@woody.linux-foundation.org>
	<46B4C0A8.1000902@garzik.org>
	<20070804191205.GA24723@lazybastard.org>
	<20070804192130.GA25346@elte.hu>
	<20070804211156.5f600d80@the-village.bc.nu>
	<20070804202830.GA4538@elte.hu>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > People just need to know about the performance differences - very few 
> > realise its more than a fraction of a percent. I'm sure Gentoo will 
> > use relatime the moment anyone knows its > 5% 8)
> 
> noatime,nodiratime gave 50% of wall-clock kernel rpm build performance 
> improvement for Dave Jones, on a beefy box. Unless i misunderstood what 
> you meant under 'fraction of a percent' your numbers are _WAY_ off.

What numbers - I didn't quote any performance numbers ?
 

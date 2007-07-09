Return-Path: <linux-kernel-owner+w=401wt.eu-S1755351AbXGIJ3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351AbXGIJ3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 05:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751501AbXGIJ2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 05:28:53 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42777 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751315AbXGIJ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 05:28:52 -0400
Date: Mon, 9 Jul 2007 10:32:23 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@stusta.de>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Please revert 21564fd2a3deb48200b595332f9ed4c9f311f2a7
Message-ID: <20070709103223.5bfe24d4@the-village.bc.nu>
In-Reply-To: <200707090102.21784.ak@suse.de>
References: <20070617214231.GA3588@stusta.de>
	<46760D87.2000502@goop.org>
	<20070708224444.GU3492@stusta.de>
	<200707090102.21784.ak@suse.de>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> It will be solved differently longer term, but short term the fix
> was still needed. There are limits on what can be done late 
> in the release cycle so simple patches win.
> 
> Besides none of the "NAK"s were particularly inspired in my opinion;
> there were no clear technical objections brought forward.


There were a considerable number of sensible logical objections. You just
didn't agree with them. You've now effectively made .22 unsupportable
since we don't know if someone has binary virtualiser crap loaded.

Alan

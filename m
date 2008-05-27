Return-Path: <linux-kernel-owner+w=401wt.eu-S1757478AbYE0KnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478AbYE0KnK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 06:43:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756369AbYE0Km6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 06:42:58 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43705 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756338AbYE0Km5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 06:42:57 -0400
Date: Tue, 27 May 2008 11:28:12 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] let GROUP_SCHED depend on BROKEN
Message-ID: <20080527112812.63697b39@core>
In-Reply-To: <20080527102654.GB20938@cs181133002.pp.htv.fi>
References: <20080527085830.GA20938@cs181133002.pp.htv.fi>
	<1211881658.6742.20.camel@marge.simson.net>
	<20080527102654.GB20938@cs181133002.pp.htv.fi>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - as long as we allow hardware drivers to depend on EXPERIMENTAL we
>   force many users to enable EXPERIMENTAL
> - the EXPERIMENTAL dependencies in many areas of the kernel are so
>   out of sync with the actual code quality that the presence or absence
>   of such a dependency isn't a clear indication of the current status

It would probably be very useful to actually do an assessment of what is
marked experimental especially a cross compare with enterprise distros as
what they ship they have reviewed and consider supportable.

Alan

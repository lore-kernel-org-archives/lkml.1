Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbXGFVfc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbXGFVfc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:35:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762411AbXGFVfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:35:23 -0400
Received: from [81.2.110.250] ([81.2.110.250]:50360 "EHLO the-village.bc.nu"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761664AbXGFVfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:35:22 -0400
Date: Fri, 6 Jul 2007 22:41:39 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Corey Minyard <minyard@acm.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Russell King <rmk+lkml@arm.linux.org.uk>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] Serial 8250: Handle saving the clear-on-read bits from
 the LSR and MSR
Message-ID: <20070706224139.4be889d6@the-village.bc.nu>
In-Reply-To: <468EB4DD.7070800@acm.org>
References: <20070706194244.GA18371@localdomain>
	<20070706210918.255a6a68@the-village.bc.nu>
	<468EB4DD.7070800@acm.org>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Testing for some time in -mm in case of side effects and then pushing it
> > to an early -rc of a new kernel
> >   
> I just pulled 2.6.22-rc6-mm1 and I looked in all the previous 2.6.22 mm 
> patches and I don't see it.  Am I missing something?

Getting it submitted into -mm as a starting point.

Alan

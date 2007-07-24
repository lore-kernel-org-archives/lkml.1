Return-Path: <linux-kernel-owner+w=401wt.eu-S1757612AbXGXPxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612AbXGXPxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 11:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751229AbXGXPxo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 11:53:44 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:37119 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750941AbXGXPxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 11:53:43 -0400
Date: Tue, 24 Jul 2007 17:00:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: corbet@lwn.net (Jonathan Corbet)
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Randy.Dunlap" <rdunlap@xenotime.net>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 1/7] lguest: documentation pt I: Preparation
Message-ID: <20070724170028.42c6bd8d@the-village.bc.nu>
In-Reply-To: <5659.1185289994@lwn.net>
References: <20070723171238.1a832b31.akpm@linux-foundation.org>
	<5659.1185289994@lwn.net>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> P.S. I am currently considering a no-limericks policy for the LWN quote
> of the week.

The LWN quote of the week
Is I think rather weak
No poems allowed
To rise from the crowd
Its future looks terribly bleak

More seriously the documentation looks good, and it definitely wants a
date/release clearly mentioning so people know when it is obsolete

> Advantage:  it does keep the source code + doc text together.
> Martin (former kernel-doc maintainer) was going to come up with
> some way to do this, but he abandoned it. 

It's not clear to me how you then format the extracted material. It
doesn't really fit the kernel-doc idea of formats. It would probably be
far easier to teach a seperate tool to rip clearly marked blocks into
ASCII documentation files for that purpose

Alan

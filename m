Return-Path: <linux-kernel-owner+w=401wt.eu-S1765715AbYDOU0Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765715AbYDOU0Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 16:26:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752318AbYDOU0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 16:26:15 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:45441 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751007AbYDOU0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 16:26:14 -0400
Date: Tue, 15 Apr 2008 20:58:19 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: hch@infradead.org, bunk@kernel.org, dwmw2@infradead.org, miklos@szeredi.hu,
       me@bobcopeland.com, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 0/7] OMFS filesystem version 3
Message-ID: <20080415205819.6340baa3@the-village.bc.nu>
In-Reply-To: <20080415130240.1b9b7662.akpm@linux-foundation.org>
References: <20080412205544.5e12a7d4.akpm@linux-foundation.org>
	<20080413080130.GA9622@infradead.org>
	<20080413012001.8d7967f4.akpm@linux-foundation.org>
	<20080413082815.GA20108@infradead.org>
	<E1JkzaV-0003Lm-NB@pomaz-ex.szeredi.hu>
	<1208121358.2700.4.camel@shinybook.infradead.org>
	<20080413154459.4b2f125d.akpm@linux-foundation.org>
	<20080413234920.63711ca7@core>
	<20080413161014.cb06964c.akpm@linux-foundation.org>
	<20080415151643.GD2454@cs181133002.pp.htv.fi>
	<20080415165727.GA8783@infradead.org>
	<20080415113452.e9eacb54.akpm@linux-foundation.org>
	<20080415195330.17f63348@the-village.bc.nu>
	<20080415130240.1b9b7662.akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > We've previously merged ones that fit this category and have one user.
> 
> Probably incorrectly.

I would disagree as drivers we've merged like that go on to have many
users or give us new developers who stay with the project (and in some
cases make projects practical to be done on Linux)

> > This is a free software project not a business enterprise.
> 
> And the same principles apply, don't they?  We seek to minimise overhead
> and to use our kernel development hours as effectively as we can.

One word if we are getting into the economics of this: Externalities.
There are lots of benefits from merging the code beyond simple value of
code merge including more developers, more reference code, more users.
The ratio of new contributions to maintenance is a different problem and
one I do not think should be conflated with it.

But yes I do think they are different - free software is largely done for
fun, by people who want to contribute. What was it John Betjeman said of
another large volunteer project:

"the result of the independent spirit which still survives in this
country and refuses to be crushed by the money-worshippers, centralizers
and the unimaginative theorists who are doing their best to kill it"

Alan

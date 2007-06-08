Return-Path: <linux-kernel-owner+w=401wt.eu-S936335AbXFHVaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936335AbXFHVaM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 17:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933422AbXFHV35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 17:29:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:58537 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753733AbXFHV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 17:29:56 -0400
Date: Fri, 8 Jun 2007 22:35:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Korb <ml@akana.de>, linux-ide@vger.kernel.org
Subject: Re: [PATCH 1/1] ide: ide-generic, add another device exception
Message-ID: <20070608223505.3ff1a662@the-village.bc.nu>
In-Reply-To: <200706081418.56217.bzolnier@gmail.com>
References: <20601315171560711667@wsc.cz>
	<200706081418.56217.bzolnier@gmail.com>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 8 Jun 2007 14:18:55 +0200
Bartlomiej Zolnierkiewicz <bzolnier@gmail.com> wrote:

> On Monday 04 June 2007, Jiri Slaby wrote:
> > ide-generic, add another device exception
> 
> ide-generic is a generic ISA IDE driver, this one is drivers/ide/pci/generic
> (a generic IDE PCI driver) - fixed patch description to avoid confusion.

Nope ide-generic is a generic I/O based ST506 interface. It covers a bit
more than just ISA bus.

> 
> [ Yes, both drivers need a rename - patches are welcomed. ]

Good way to break everyones module settings

Alan

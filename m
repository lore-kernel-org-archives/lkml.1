Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbXGBNkI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbXGBNkI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2007 09:40:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755037AbXGBNj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jul 2007 09:39:57 -0400
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:42053 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754926AbXGBNj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2007 09:39:57 -0400
Date: Mon, 2 Jul 2007 14:46:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "Robert P. J. Day" <rpjday@mindspring.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       eng.linux@digi.com
Subject: Re: [PATCH][RFC] Remove support for the orphaned, obsolete Digi
 EPCA driver.
Message-ID: <20070702144605.5cf99b3a@the-village.bc.nu>
In-Reply-To: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
References: <Pine.LNX.4.64.0707020906530.19712@localhost.localdomain>
X-Mailer: Claws Mail 2.9.1 (GTK+ 2.10.8; i386-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2007 09:14:24 -0400 (EDT)
"Robert P. J. Day" <rpjday@mindspring.com> wrote:

> 
> Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
> 
> ---
> 
>   everything indicates that this driver is thoroughly dead.  the
> MAINTAINERS file describes it as "Orphaned", while the file
> Documentation/digiepca.txt reads:

NAK

> "NOTE:  This driver is obsolete.  Digi provides a 2.6 driver (dgdm) at
> http://www.digi.com for PCI cards.  They no longer maintain this driver,
> and have no 2.6 driver for ISA cards.

This driver is obsolete from the kernel at the point the new digi drivers
are merged.

> This driver requires a number of user-space tools.  They can be acquired from
> http://www.digi.com, but only works with 2.4 kernels."

So fix them or merge the newer digi drivers first.

Alan
